resource "google_project_iam_custom_role" "this" {
  role_id     = var.name
  title       = var.title
  description = var.description
  permissions = var.permissions
}
