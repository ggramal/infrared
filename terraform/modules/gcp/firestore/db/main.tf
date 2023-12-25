resource "google_firestore_database" "this" {
  count                       = var.app_engine_integration_mode == "DISABLED" ? 1 : 0
  name                        = var.name
  location_id                 = var.location_id
  type                        = var.type
  concurrency_mode            = var.concurrency_mode
  app_engine_integration_mode = var.app_engine_integration_mode
  delete_protection_state     = var.delete_protection_state
  deletion_policy             = var.deletion_policy
}


resource "google_app_engine_application" "this" {
  count         = var.app_engine_integration_mode == "ENABLED" ? 1 : 0
  project       = data.google_project.project.project_id
  location_id   = var.location_id
  database_type = "CLOUD_DATASTORE_COMPATIBILITY"
}


data "google_project" "project" {}
