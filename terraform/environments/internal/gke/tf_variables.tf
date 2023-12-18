locals {
  gke_clusters = {
    int = {
      location = var.gcp_projects["int"].region
      project  = var.gcp_projects["int"].name
      enabled  = true
    }
  }
  remote_state_config = {
  }

  remote_state = {
  }
}

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
