locals {
  prometheus = {
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
    thanos-int = {
      name = "thanos"
      secrets_data = {
        #used in prometheus thanos
        #sidecar
        #used for thanos components
        "objstore.yml" = <<EOF
type: GCS
config:
  bucket: "${var.company.name}-thanos-int"
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
    thanos-prd = {
      name = "thanos-prd"
      secrets_data = {
        #used for thanos prod cluster
        #components
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
    thanos-dev = {
      name = "thanos-dev"
      secrets_data = {
        #used for thanos dev cluster
        #components
        "objstore.yml" = <<EOF
type: GCS
config:
  bucket: "${var.company.name}-thanos-dev"
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
  }
}
