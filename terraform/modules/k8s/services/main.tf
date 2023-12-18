resource "kubernetes_service" "external" {
  for_each = {
    for service_name, service_obj in var.external :
    "${service_name}.${service_obj.namespace}" => service_obj
  }
  metadata {
    name      = split(".", each.key)[0]
    namespace = each.value.namespace
  }

  spec {
    external_name = each.value.external_name
    type          = "ExternalName"
  }
}
