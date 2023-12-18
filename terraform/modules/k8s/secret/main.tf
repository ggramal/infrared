resource "kubernetes_secret" "secret" {
  metadata {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    labels      = var.labels
  }

  data = var.data
}
