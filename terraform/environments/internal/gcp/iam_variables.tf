locals {
  iam = {
    custom_roles = {
      k8sNodeServiceAccount = {
        title       = "k8s node service account"
        description = "Cusom role for k8s node service accounts without the bucket read permission"
        permissions = [
          "autoscaling.sites.writeMetrics",
          "logging.logEntries.create",
          "monitoring.metricDescriptors.create",
          "monitoring.metricDescriptors.list",
          "monitoring.timeSeries.create",
          "monitoring.timeSeries.list",
          "resourcemanager.projects.get",
          "serviceusage.services.use",
        ]
        members = [
          "serviceAccount:k8s-nodes@${var.gcp_projects.int.name}.iam.gserviceaccount.com"
        ]
      }
    }

    service_accounts = {
      external-dns = {
        description = "k8s sigs external dns service account"
        roles = [
          "roles/dns.admin"
        ]
        custom_roles = []
        sa_iam_bindings = {
          "roles/iam.workloadIdentityUser" = [
            "serviceAccount:${var.gcp_projects.int.name}.svc.id.goog[external-dns/external-dns]",
          ]
        }
        generate_key = false
      },
      argocd = {
        description = "argocd service account"
        roles = [
        ]
        custom_roles = []
        sa_iam_bindings = {
          "roles/iam.workloadIdentityUser" = [
            "serviceAccount:${var.gcp_projects.int.name}.svc.id.goog[argocd/argocd-application-controller]",
            "serviceAccount:${var.gcp_projects.int.name}.svc.id.goog[argocd/argocd-server]",
          ]
        }
        generate_key = false
      },
      k8s-nodes = {
        description  = "default service account for k8s nodes"
        roles        = []
        custom_roles = []
        sa_iam_bindings = {
        }
        generate_key = false
      }
      thanos = {
        description  = "service account for thanos"
        roles        = []
        custom_roles = []
        sa_iam_bindings = {
          "roles/iam.workloadIdentityUser" = [
            "serviceAccount:${var.gcp_projects.int.name}.svc.id.goog[prometheus/prometheus-gcp-int-prometheus-main]",
            "serviceAccount:${var.gcp_projects.int.name}.svc.id.goog[prometheus/thanos-gcp-int-int-compactor]",
            "serviceAccount:${var.gcp_projects.int.name}.svc.id.goog[prometheus/thanos-gcp-int-int-storegateway]",
            "serviceAccount:${var.gcp_projects.int.name}.svc.id.goog[prometheus/thanos-gcp-int-prd-storegateway]",
            "serviceAccount:${var.gcp_projects.int.name}.svc.id.goog[prometheus/thanos-gcp-int-dev-storegateway]",
          ]
        }
        generate_key = false
      }
    }

    roles = {
      owners = {
        role = "roles/owner"
        members = [
        ]
      }
    }
  }
}
