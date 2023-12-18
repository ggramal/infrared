module "projects" {
  source   = "./project"
  for_each = var.projects
  project  = merge(each.value, { name = each.key })
}

module "clusters" {
  source   = "./cluster"
  for_each = var.clusters
  cluster  = merge(each.value, { name = each.key })
}

module "teams" {
  source   = "./team"
  for_each = var.teams
  team     = merge(each.value, { name = each.key })
}

module "database_users" {
  source   = "./database_user"
  for_each = var.database_users
  user     = merge(each.value, { name = each.key })
}
