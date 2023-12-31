resource "google_project_iam_member" "this" {
  for_each = toset(var.members)
  project  = var.project_id
  role     = var.role

  member = each.value
}
