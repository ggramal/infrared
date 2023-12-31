resource "google_service_account" "this" {
  account_id   = var.name
  display_name = var.name
  description  = var.description
}

resource "google_service_account_key" "this" {
  count              = var.generate_key == true ? 1 : 0
  service_account_id = google_service_account.this.name
}

resource "google_project_iam_member" "roles" {
  for_each = toset(var.roles)
  role     = each.value
  project  = var.project_id
  member   = google_service_account.this.member

  depends_on = [
    google_service_account.this
  ]
}

resource "google_service_account_iam_binding" "bindings" {
  for_each           = var.sa_iam_bindings
  service_account_id = google_service_account.this.id
  role               = each.key
  members            = each.value

  depends_on = [
    google_service_account.this
  ]
}

