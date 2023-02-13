variable "digital_ocean_token" {
  type = string
  sensitive = true
}
variable "aws_access_token" {
  type = string
  sensitive = true
}
variable "aws_secret_key" {
  type = string
  sensitive = true
}
variable "list_application_servers" {
    type = list
}
variable "server_parameters" {
    type = map
}
variable "group_name" {
    type = map
}
variable "user_info" {
    type = map
}
variable "subvendor" {
  type = map
}