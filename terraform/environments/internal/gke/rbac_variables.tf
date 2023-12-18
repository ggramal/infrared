locals {
  rbac = {
    service_accounts = {
      external-dns = {
        namespace = "external-dns"
        name      = "external-dns"
        annotations = {
          "iam.gke.io/gcp-service-account" = "external-dns@${var.gcp_projects["int"].name}.iam.gserviceaccount.com"
        }
      }
    }
    cluster_roles = {
    }
    cluster_role_binding = {
    }
    roles        = {}
    role_binding = {}
  }
}
