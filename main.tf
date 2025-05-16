terraform {
  required_version = ">= 1.4"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "random" {}

resource "random_id" "test" {
  byte_length = 4
}

