output "servers_ip4_address" {
  value = digitalocean_droplet.app_server.*.ipv4_address
}