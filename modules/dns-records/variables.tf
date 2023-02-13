variable "subvendor" {
    type = map
}
variable "servers_ip4_address" {
    type = list
}
variable "list_application_servers" {
    type = list
}
variable "list_of_dns" {
    type = list
}
variable "aws_access_token" {
  type = string
  sensitive = true
}
variable "aws_secret_key" {
  type = string
  sensitive = true
}