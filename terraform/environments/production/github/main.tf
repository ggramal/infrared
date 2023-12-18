terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "5.37.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }
  required_version = "~> 1.5"
  backend "gcs" {
    bucket = "exampleco-tf-state"
    prefix = "production/github"
  }
}

provider "github" {
  owner = var.github.org
}

data "terraform_remote_state" "remote_state" {
  for_each = local.remote_state_config
  backend  = "gcs"

  config = each.value.config
}

module "github" {
  source       = "../../../modules/github"
  repositories = local.repos
}
