terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
    }
    postgresql = {
      source = "cyrilgdn/postgresql"
    }
  }
  required_version = ">= 0.13"
}
