module "droplets" {
  source   = "../../modules/droplet-do"

  digital_ocean_token         = var.digital_ocean_token
  server_parameters           = var.server_parameters
  list_application_servers    = local.list_of_servers
  user_info                   = var.user_info
  subvendor                   = var.subvendor
  transport_password          = local.random_string_cache
}

module "dns" {
  source              = "../../modules/dns-records"

  list_of_dns               = local.list_of_dns
  list_application_servers  = local.list_of_servers
  servers_ip4_address       = module.droplets.servers_ip4_address
  subvendor                 = var.subvendor
  aws_access_token          = var.aws_access_token
  aws_secret_key            = var.aws_secret_key
}

locals {
  	list_of_servers     = [for idx, server in var.list_application_servers : "${server}-${var.group_name["dev"]}"]
	  list_of_dns 	      = [for idx, server in var.list_application_servers : "${var.user_info["login"]}-${idx+1}"]
	  random_string_cache = tolist(nonsensitive(toset(random_password.password.*.result)))
}

# Gen random string 
resource "random_password" "password" {
	count 			 = length(local.list_of_servers)
  	length           = 16
  	special          = true
  	override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Save server_info into the file
resource "local_sensitive_file" "foo" {
    content  = 	templatefile("${path.module}/templates/server_details.tftpl", 
								{
                  rebrain_dns_zone  = var.subvendor["dns_base_zone"], 
                  dns               = local.list_of_dns, 
                  servers           = local.list_of_servers,
                  ip                = module.droplets.servers_ip4_address
                  pass              = local.random_string_cache
                })
    filename = "${path.module}/outputs/server_details.info"
}
