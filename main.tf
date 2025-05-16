terraform {
  required_version = ">= 1.4"
}

resource "terraform_data" "dummy" {
  input = timestamp()
}
