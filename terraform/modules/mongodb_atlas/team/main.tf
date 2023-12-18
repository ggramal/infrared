resource "mongodbatlas_teams" "this" {
  org_id    = local.team.org_id
  name      = local.team.name
  usernames = local.team.usernames
}
