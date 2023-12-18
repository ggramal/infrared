locals {
  iam_roles = flatten(
    [
      for key_name, key_obj in var.keys :
      [
        for iam_role_obj in key_obj.iam_roles :
        {
          "key"   = key_name
          role    = iam_role_obj.role
          members = iam_role_obj.members
        }
      ]
    ]
  )

}

# Create a KMS key ring
resource "google_kms_key_ring" "key_ring" {
  name     = var.key_ring.name
  location = var.key_ring.location
}

# Create a crypto key for the key ring
resource "google_kms_crypto_key" "keys" {
  for_each        = var.keys
  name            = each.value.name
  key_ring        = google_kms_key_ring.key_ring.id
  rotation_period = each.value.rotation_period
  purpose         = each.value.purpose

  version_template {
    algorithm        = each.value.algorithm
    protection_level = each.value.protection_level
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_crypto_key_iam_binding" "keys" {
  for_each = {
    for iam_role_obj in local.iam_roles :
    "${iam_role_obj.key}.${iam_role_obj.role}" => iam_role_obj
  }
  crypto_key_id = google_kms_crypto_key.keys[each.value.key].id
  role          = each.value.role

  members = each.value.members
}
