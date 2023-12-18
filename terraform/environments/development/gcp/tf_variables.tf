locals {
  remote_state_config = {
  }

  remote_state = {
  }
}


data "google_project" "project" {}

data "google_client_config" "current" {}

data "google_compute_zones" "available" {}

variable "company" {
  description = "Company related info"
  type = object(
    {
      name   = string
      domain = string
    }
  )
}

variable "gcp_projects" {
  description = "Definitions of gcp projects"
  type = map(
    object(
      {
        name         = string
        env_name     = string
        region       = string
        default_zone = string
        multi_region = string
        gcr_region   = string
      }
    )
  )
}
