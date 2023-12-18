locals {
  gcs_bucket = "${var.registry.gcr_bucket_prefix}.artifacts.${var.project_id}.appspot.com"
}

resource "google_container_registry" "registry" {
  count    = var.registry.create ? 1 : 0
  location = var.registry.location
}

resource "google_storage_bucket_iam_binding" "pullers" {
  count   = length(var.pullers) > 0 ? 1 : 0
  bucket  = var.registry.create ? google_container_registry.registry[0].id : trim(local.gcs_bucket, ".")
  role    = "roles/storage.objectViewer"
  members = var.pullers
}

resource "google_storage_bucket_iam_binding" "pushers" {
  count   = length(var.pushers) > 0 ? 1 : 0
  bucket  = var.registry.create ? google_container_registry.registry[0].id : trim(local.gcs_bucket, ".")
  role    = "roles/storage.admin"
  members = var.pushers
}
