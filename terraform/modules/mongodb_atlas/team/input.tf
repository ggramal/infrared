locals {
  team = {
    org_id    = var.team.org_id
    name      = var.team.name
    usernames = var.team.usernames
  }
}

variable "team" {
  type = any
}
