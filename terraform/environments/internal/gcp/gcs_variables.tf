locals {
  gcs = {
    "${var.company.name}-thanos-int" = {
      prefix             = ""
      storage_class      = "MULTI_REGIONAL"
      location           = "EU"
      bucket_policy_only = false
      admins = [
        "serviceAccount:thanos@${var.gcp_projects.int.name}.iam.gserviceaccount.com"
      ]
      viewers = [
      ]
      creators        = []
      versioning      = true
      lifecycle_rules = []
      cors            = []
    }
  }
}
