locals {
  gke_clusters = {
    prd = {
      location = var.gcp_projects["prd"].region
      project  = var.gcp_projects["prd"].name
      enabled  = true
    }
  }

  remote_state_config = {
    gcp = {
      config = {
        bucket = "${var.company.name}-tf-state"
        prefix = "${var.gcp_projects["prd"].env_name}/gcp"
      }
    }
  }

  remote_state = {
    gcp = {
      service_accounts = data.terraform_remote_state.remote_state["gcp"].outputs.service_accounts
    }
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
