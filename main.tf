terraform {
  required_version = ">= 1.4"
}

terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

resource "random_pet" "test" {
  length = 2
}
