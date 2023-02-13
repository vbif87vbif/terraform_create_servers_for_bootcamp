terraform {
	required_providers {
		random = {
			source  = "hashicorp/random"
			version = "~> 3.1.3"
		}
		local = {
			source  = "hashicorp/local"
			version = "2.2.2"
		}
	}
}