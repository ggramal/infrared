resource "mongodbatlas_project" "this" {
  name   = local.project.name
  org_id = local.project.org_id

  dynamic "teams" {
    for_each = local.project.teams
    content {
      team_id    = teams.value.team_id
      role_names = teams.value.role_names
    }
  }
}

resource "mongodbatlas_project_ip_access_list" "this" {
  for_each   = local.project.ip_access_list
  project_id = mongodbatlas_project.this.id
  cidr_block = each.value.cidr_block
  comment    = each.value.comment
}
