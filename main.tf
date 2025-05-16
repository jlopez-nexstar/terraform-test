terraform {
  required_version = ">= 1.4"
}

resource "null_resource" "dummy" {
  triggers = {
    always = uuid()
  }
}
