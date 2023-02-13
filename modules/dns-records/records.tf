data "aws_route53_zone" "dns_base_zone" {
  	name = var.subvendor["dns_base_zone"]
}

resource "aws_route53_record" "www" {
	count 	= length(var.list_application_servers)
	zone_id = data.aws_route53_zone.dns_base_zone.zone_id
	name    = var.list_of_dns[count.index]
	type    = "A"
	ttl     = "300"
	records = [element(var.servers_ip4_address, count.index)]
}