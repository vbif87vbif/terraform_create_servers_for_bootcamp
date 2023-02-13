locals {
	random_string_cache = var.transport_password
	json_data = jsondecode(data.http.get_ssh_keys.body)["ssh_keys"]
  	user_public_ssh_key_id = [for idx, val in local.json_data : local.json_data[idx]["id"] if local.json_data[idx]["public_key"] == var.user_info["pub_ssh_key_value"]]
  	subvendor_ssh_key_id = [for idx, val in local.json_data : local.json_data[idx]["id"] if local.json_data[idx]["public_key"] == var.subvendor["pub_ssh_key"]]
}	

data "http" "get_ssh_keys" {
  	url = "${var.digital_ocean_api_url}/${var.digital_ocean_ssh_keys_api_method}"

	# request headers
	request_headers = {
		Accept = "application/json"
		Authorization = "Bearer ${var.digital_ocean_token}"
	}
}

# Add user public key as resource if didn't create before
resource "digitalocean_ssh_key" "user_pub_ssh_key_res" {
	count 		= (length(local.user_public_ssh_key_id)==1) ? 0 : 1
	name		= var.user_info["pub_ssh_key_name"]
	public_key	= var.user_info["pub_ssh_key_value"]
}


# Create droplet
resource "digitalocean_droplet" "app_server" {

	count				= length(var.list_application_servers)
	
    name                = var.list_application_servers[count.index]
	image               = var.server_parameters["image"]
	region              = var.server_parameters["region"]
	size                = var.server_parameters["size"]
	monitoring          = var.server_parameters["monitoring"]

	tags = [
		"task_name:${var.user_info["tag_task_name"]}",
		"user_email:${var.user_info["tag_user_email"]}"
	]

	#add rebrain and my public key (new from resource or existing from data)
	#compact for remove null values if exists
	ssh_keys = compact([
			local.subvendor_ssh_key_id[0],
			((length(local.user_public_ssh_key_id) == 0) ? 
							digitalocean_ssh_key.user_pub_ssh_key_res[0].id : 
							local.user_public_ssh_key_id[0])]
	)

	provisioner "remote-exec" {
		inline = [
			"sudo sh -c 'echo root:\"${local.random_string_cache[count.index]}\" | chpasswd'"
		]
	}

	connection {
		host        = self.ipv4_address
		type        = "ssh"
		user        = "root"
		private_key = file(pathexpand(var.user_info["private_key_path"]))
	}
}