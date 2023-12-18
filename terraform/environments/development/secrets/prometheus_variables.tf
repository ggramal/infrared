locals {
  prometheus = {
    thanos = {
      name = "thanos"
      secrets_data = {
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
