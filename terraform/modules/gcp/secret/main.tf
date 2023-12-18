resource "google_secret_manager_secret" "secret" {
  secret_id = var.name

  labels = var.labels

  annotations = var.annotations

  replication {
    auto {
      dynamic "customer_managed_encryption" {
        for_each = var.kms_key != null ? {
          kms = var.kms_key
        } : {}
        content {
          kms_key_name = customer_managed_encryption.value
        }
      }
    }
  }
}


resource "google_secret_manager_secret_iam_binding" "secret" {
  for_each = {
    for iam_role_obj in var.iam_roles :
    iam_role_obj.role => iam_role_obj
  }
  secret_id = google_secret_manager_secret.secret.secret_id
  role      = each.value.role

  members = each.value.members
}

resource "google_secret_manager_secret_version" "secret" {
  secret = google_secret_manager_secret.secret.id

  is_secret_data_base64 = var.is_base64
  secret_data           = var.secret
}
