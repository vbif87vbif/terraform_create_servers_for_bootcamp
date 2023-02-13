terraform {
	required_providers {
		aws = {
			source  = "hashicorp/aws"
			version = "~> 3.0"
		}
	}
}
# Configure the AWS Provider
provider "aws" {
	region     = "us-west-2"
	access_key = var.aws_access_token
	secret_key = var.aws_secret_key
}