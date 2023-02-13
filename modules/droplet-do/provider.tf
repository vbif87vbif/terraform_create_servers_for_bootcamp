terraform {
	required_providers {
		digitalocean = {
			source = "digitalocean/digitalocean"
			version = "~> 2.0"
		}
		http = {
			version = "2.1.0"
			source  = "hashicorp/http"
		}
	}
}
# Configure the DigitalOcean Provider
provider "digitalocean" {
	token = var.digital_ocean_token
}