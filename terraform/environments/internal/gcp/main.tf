provider "google" {
  project = var.gcp_projects.int.name
  region  = var.gcp_projects.int.region
  zone    = var.gcp_projects.int.default_zone
}

provider "google-beta" {
  project = var.gcp_projects.int.name
  region  = var.gcp_projects.int.region
  zone    = var.gcp_projects.int.default_zone
}


terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    google-beta = {
      source = "hashicorp/google-beta"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = "~> 1.5"
  backend "gcs" {
    bucket = "exampleco-tf-state"
    prefix = "internal/gcp"
  }
}

data "terraform_remote_state" "remote_state" {
  for_each = local.remote_state_config
  backend  = "gcs"

  config = each.value.config
}


module "gcp" {
  source = "../../../modules/gcp"
  project = {
    id     = var.gcp_projects.int.name
    region = var.gcp_projects.int.region
  }

  activate_apis = local.activate_apis
  networks      = local.networks
  gke_clusters  = local.gke_clusters
  iam           = local.iam
  dns_zones     = local.dns_zones
  gcs           = local.gcs
}
