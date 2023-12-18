locals {
  gke_clusters = {
    int = {
      location = var.gcp_projects["int"].region
      project  = var.gcp_projects["int"].name
      enabled  = true
    }
    dev = {
      location = "${var.gcp_projects["dev"].region}-a"
      project  = var.gcp_projects["dev"].name
      enabled  = true
    }
    prd = {
      location = var.gcp_projects["prd"].region
      project  = var.gcp_projects["prd"].name
      enabled  = true
    }
  }

  remote_state_config = {
    github = {
      config = {
        bucket = "${var.company.name}-tf-state"
        prefix = "${var.gcp_projects["prd"].env_name}/github"
      }
    }
  }

  remote_state = {
    github = {
      repos = data.terraform_remote_state.remote_state["github"].outputs.repos
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
