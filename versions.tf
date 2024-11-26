
terraform {
  required_version = ">= 0.13"
  archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.12.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
}
