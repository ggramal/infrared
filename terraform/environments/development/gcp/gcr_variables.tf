locals {
  gcrs = {
    main = {
      pullers = [
        "serviceAccount:k8s-nodes@${var.gcp_projects.dev.name}.iam.gserviceaccount.com"
      ]
      pushers = [
        "serviceAccount:container-images@${var.gcp_projects.dev.name}.iam.gserviceaccount.com"
      ]
      registry = {
        create   = true
        location = var.gcp_projects.dev.gcr_region
      }
    }
  }
}
