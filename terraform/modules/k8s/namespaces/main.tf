resource "kubernetes_namespace" "namespaces" {
  for_each = var.namespaces
  metadata {
    annotations = each.value.annotations
    labels      = each.value.labels
    name        = each.value.name
  }
}
