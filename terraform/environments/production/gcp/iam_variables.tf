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
          "serviceAccount:k8s-nodes@${var.gcp_projects.prd.name}.iam.gserviceaccount.com"
        ]
      }
      bucketList = {
        title       = "List/get buckets for services"
        description = "Custom role for listing buckets and there metadata"
        permissions = [
          "resourcemanager.projects.get",
          "storage.buckets.list",
          "storage.buckets.get",
        ]
        members = [
        ]
      }
    }

    service_accounts = {
      k8s-nodes = {
        description = "default service account for k8s nodes"
        roles = [
        ]
        custom_roles = []
        sa_iam_bindings = {
        }
        generate_key = false
      }
      external-dns = {
        description = "k8s sigs external dns service account"
        roles = [
          "roles/dns.admin"
        ]
        custom_roles = []
        sa_iam_bindings = {
          "roles/iam.workloadIdentityUser" = [
            "serviceAccount:${var.gcp_projects.prd.name}.svc.id.goog[external-dns/external-dns]",
          ]
        }
        generate_key = false
      },
      container-images = {
        description = "Account for pulling/pushing images from/to gcr"
        roles = [
        ]
        custom_roles = []
        sa_iam_bindings = {
        }
        generate_key = true
      }
      thanos = {
        description  = "service account for thanos"
        roles        = []
        custom_roles = []
        sa_iam_bindings = {
          "roles/iam.workloadIdentityUser" = [
            "serviceAccount:${var.gcp_projects.prd.name}.svc.id.goog[prometheus/prometheus-gcp-prd-prometheus-main]",
            "serviceAccount:${var.gcp_projects.prd.name}.svc.id.goog[prometheus/thanos-gcp-prd-prd-compactor]",
          ]
        }
        generate_key = false
      }
      postgres = {
        description = "service account for postgres-operator to store wal-e archiving"
        roles       = []
        custom_roles = [
          "bucketList"
        ]
        sa_iam_bindings = {
          "roles/iam.workloadIdentityUser" = [
            "serviceAccount:${var.gcp_projects.prd.name}.svc.id.goog[postgres/postgres]",
          ]
        }
        generate_key = true
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
