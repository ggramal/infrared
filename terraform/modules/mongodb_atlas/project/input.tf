locals {
  project = {
    name   = var.project.name
    org_id = var.project.org_id
    teams = [
      for team in var.project.teams :
      {
        team_id    = team.team_id
        role_names = team.role_names
      }
    ]
    ip_access_list = {
      for name, ip_access in var.project.ip_access_list :
      name => {
        cidr_block = ip_access.cidr_block
        comment    = ip_access.comment
      }
    }
  }
}

variable "project" {
  type = any
}
