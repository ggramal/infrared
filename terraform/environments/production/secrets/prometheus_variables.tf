locals {
  prometheus = {
    thanos = {
      name = "thanos"
      secrets_data = {
        "objstore.yml" = <<EOF
type: GCS
config:
  bucket: "${var.company.name}-thanos-prd"
prefix: ""
EOF

      }
      k8s = {
        enabled   = true
        namespace = "prometheus"
      }
      annotations = {
      }
      labels = {
      }
    }
    alertmanager = {
      name = "alertmanager"
      secrets_to_import = [
        "SLACK_WEBHOOK"
      ]
      k8s = {
        enabled   = true
        namespace = "prometheus"
      }
      annotations = {
      }
      labels = {
      }
    }
  }
}
