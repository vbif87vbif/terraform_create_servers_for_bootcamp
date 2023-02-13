variable "digital_ocean_token" {
  type = string
  sensitive = true
}
variable "list_application_servers" {
    type = list
}
variable "server_parameters" {
    type = map
}
variable "user_info" {
    type = map
}
variable "digital_ocean_api_url" {
  type = string
  default="https://api.digitalocean.com/v2"
}
variable "digital_ocean_ssh_keys_api_method" {
  type = string
  default="account/keys?per_page=200"
}
variable "subvendor" {
  type = map
}
variable "transport_password" {
    type = list
}