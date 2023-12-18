locals {
  gke_clusters = {
    prd = {
      location = var.gcp_projects["prd"].region
      project  = var.gcp_projects["prd"].name
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
        region       = string
        env_name     = string
        default_zone = string
        multi_region = string
        gcr_region   = string
      }
    )
  )
}
