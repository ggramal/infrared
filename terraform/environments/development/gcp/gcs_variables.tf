locals {
  gcs = {
    "${var.company.name}-thanos-dev" = {
      prefix             = ""
      storage_class      = "MULTI_REGIONAL"
      location           = "EU"
      bucket_policy_only = false
      admins = [
        "serviceAccount:thanos@${var.gcp_projects.dev.name}.iam.gserviceaccount.com"
      ]
      viewers = [
        "serviceAccount:thanos@${var.gcp_projects.int.name}.iam.gserviceaccount.com"
      ]
      creators        = []
      versioning      = true
      lifecycle_rules = []
      cors            = []
    }
    "${var.company.name}-postgres-dev" = {
      prefix             = ""
      storage_class      = "MULTI_REGIONAL"
      location           = "EU"
      bucket_policy_only = false
      admins = [
        "serviceAccount:postgres@${var.gcp_projects.dev.name}.iam.gserviceaccount.com"
      ]
      viewers = [
      ]
      creators        = []
      versioning      = true
      lifecycle_rules = []
      cors            = []
    }
    "${var.company.name}-postgres-backup-dev" = {
      prefix             = ""
      storage_class      = "MULTI_REGIONAL"
      location           = "EU"
      bucket_policy_only = false
      admins = [
        "serviceAccount:postgres@${var.gcp_projects.dev.name}.iam.gserviceaccount.com"
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
