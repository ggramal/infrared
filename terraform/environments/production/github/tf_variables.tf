locals {
  remote_state_config = {
    gcp = {
      config = {
        bucket = "${var.company.name}-tf-state"
        prefix = "production/gcp"
      }
    }
    gcp-dev = {
      config = {
        bucket = "${var.company.name}-tf-state"
        prefix = "development/gcp"
      }
    }
  }

  remote_state = {
    gcp = {
      service_accounts = data.terraform_remote_state.remote_state["gcp"].outputs.service_accounts
    }
    gcp-dev = {
      service_accounts = data.terraform_remote_state.remote_state["gcp-dev"].outputs.service_accounts
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

variable "github" {
  description = "github related info"
  type = object(
    {
      org = string
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
