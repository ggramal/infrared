resource "google_cloud_run_v2_service" "this" {
  name     = var.name
  location = var.location
  ingress  = var.ingress

  template {
    execution_environment = var.execution_environment
    service_account       = var.service_account
    dynamic "volumes" {
      for_each = var.volumes
      content {
        name = volumes.value.name
        secret {
          secret = volumes.value.secret.secret
          items {
            version = volumes.value.secret.items.version
            path    = volumes.value.secret.items.path
          }
        }
      }
    }

    containers {
      image = var.container.image

      dynamic "volume_mounts" {
        for_each = var.container.volume_mounts == null ? {} : var.container.volume_mounts
        content {
          name       = volume_mounts.value.name
          mount_path = volume_mounts.value.path
        }
      }

      dynamic "ports" {
        for_each = var.container.ports
        content {
          container_port = ports.value.container_port
          name           = ports.value.name
        }
      }

      dynamic "env" {
        for_each = var.container.env
        content {
          name  = env.value.name
          value = env.value.value
          dynamic "value_source" {
            for_each = env.value.secret_key_ref != null ? {
              "secret_key_ref" = env.value.secret_key_ref
            } : {}
            content {
              secret_key_ref {
                secret  = value_source.value.secret
                version = value_source.value.version
              }
            }
          }
        }
      }

      resources {
        limits = {
          memory = var.container.resources.limits.memory
          cpu    = var.container.resources.limits.cpu
        }
        cpu_idle          = var.container.resources.cpu_idle
        startup_cpu_boost = var.container.resources.startup_cpu_boost
      }
    }

    dynamic "vpc_access" {
      for_each = var.vpc_access != null ? [
        var.vpc_access
      ] : []
      content {
        connector = vpc_access.value.connector
        egress    = vpc_access.value.egress
      }
    }

    scaling {
      min_instance_count = var.scaling.min_instance_count
      max_instance_count = var.scaling.max_instance_count
    }
  }
  lifecycle {
    ignore_changes = [
      template[0].containers[0].image,
      client,
      client_version
    ]
  }
}

resource "google_cloud_run_service_iam_member" "authorize" {
  count    = length(var.members)
  location = google_cloud_run_v2_service.this.location
  project  = google_cloud_run_v2_service.this.project
  service  = google_cloud_run_v2_service.this.name
  role     = "roles/run.invoker"
  member   = var.members[count.index]
}

resource "google_compute_region_network_endpoint_group" "this" {
  count                 = var.neg_enabled ? 1 : 0
  name                  = "${var.name}-neg"
  region                = var.location
  network_endpoint_type = "SERVERLESS"
  cloud_run {
    service = google_cloud_run_v2_service.this.name
  }
}
