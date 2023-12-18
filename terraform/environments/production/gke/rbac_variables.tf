locals {
  rbac = {
    service_accounts = {
      external-dns = {
        name      = "external-dns"
        namespace = "external-dns"
        annotations = {
          "iam.gke.io/gcp-service-account" = "external-dns@${var.gcp_projects["prd"].name}.iam.gserviceaccount.com"
        }
      }
      "postgres.postgres" = {
        name      = "postgres"
        namespace = "postgres"
        annotations = {
          "iam.gke.io/gcp-service-account" = "postgres@${var.gcp_projects["prd"].name}.iam.gserviceaccount.com"
        }
      }
    }
    cluster_roles = {
    }
    cluster_role_binding = {
      argocd = {
        labels      = {},
        annotations = {},
        role_ref = {
          kind = "ClusterRole"
          name = "cluster-admin"
        }
        subject = {
          argocd = {
            api_group = "rbac.authorization.k8s.io"
            kind      = "User"
            name      = "argocd@${var.gcp_projects.int.name}.iam.gserviceaccount.com"
            namespace = ""
          }
        }
      }
    }
    roles        = {}
    role_binding = {}
  }
}
