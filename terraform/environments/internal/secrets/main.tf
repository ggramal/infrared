terraform {
  required_providers {
    secret = {
      source  = "inspectorioinc/secret"
      version = "1.1.4"
    }
    google = {
      source = "hashicorp/google"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }

  required_version = "~> 1.4"

  backend "gcs" {
    bucket = "exampleco-tf-state"
    prefix = "internal/secrets"
  }
}

data "terraform_remote_state" "remote_state" {
  for_each = local.remote_state_config
  backend  = "gcs"

  config = each.value.config
}

data "google_client_config" "provider" {}

data "google_container_cluster" "gke_clusters" {
  for_each = {
    for gke_cluster_name, gke_cluster_obj in local.gke_clusters :
    gke_cluster_name => gke_cluster_obj
    if gke_cluster_obj.enabled
  }
  name     = each.key
  location = each.value.location
  project  = each.value.project
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.gke_clusters["int"].endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.gke_clusters["int"].master_auth[0].cluster_ca_certificate
  )
}

module "secrets" {
  source  = "../../../modules/secrets"
  secrets = local.secrets
}
