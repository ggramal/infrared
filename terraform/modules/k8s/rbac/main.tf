resource "kubernetes_service_account" "service_account" {

  for_each = {
    for service_account_name, service_account_obj in var.custom_service_accounts :
    "${service_account_obj.name}.${service_account_obj.namespace}" =>
    service_account_obj
  }

  metadata {
    name        = each.value.name
    namespace   = each.value.namespace
    annotations = each.value.annotations
  }
  dynamic "secret" {
    for_each = each.value.secret
    content {
      name = secret.value["name"]
    }
  }
  automount_service_account_token = each.value.automount_service_account_token
}

resource "kubernetes_cluster_role" "cluster_role" {
  for_each = var.custom_cluster_roles
  metadata {
    name        = each.key
    labels      = each.value.labels
    annotations = each.value.annotations
  }

  dynamic "rule" {
    for_each = each.value.rule
    content {
      api_groups        = rule.value["api_groups"]
      resources         = rule.value["resources"]
      resource_names    = rule.value["resource_names"]
      verbs             = rule.value["verbs"]
      non_resource_urls = rule.value["non_resource_urls"]
    }
  }
}

resource "kubernetes_cluster_role_binding" "cluster_role_binding" {
  for_each = var.custom_cluster_role_binding
  metadata {
    name        = each.key
    labels      = each.value.labels
    annotations = each.value.annotations
  }
  role_ref {
    kind      = each.value.role_ref.kind
    name      = each.value.role_ref.name
    api_group = "rbac.authorization.k8s.io"
  }
  dynamic "subject" {
    for_each = each.value.subject
    content {
      api_group = subject.value["api_group"]
      kind      = subject.value["kind"]
      name      = subject.value["name"]
      namespace = subject.value["namespace"]
    }
  }
  depends_on = [kubernetes_cluster_role.cluster_role, kubernetes_service_account.service_account]
}


resource "kubernetes_role" "role" {
  for_each = var.custom_roles
  metadata {
    name        = each.key
    labels      = each.value.labels
    namespace   = each.value.namespace
    annotations = each.value.annotations
  }

  dynamic "rule" {
    for_each = each.value.rule
    content {
      api_groups     = rule.value["api_groups"]
      resources      = rule.value["resources"]
      resource_names = rule.value["resource_names"]
      verbs          = rule.value["verbs"]
    }
  }
}
resource "kubernetes_role_binding" "role_binding" {
  for_each = var.custom_role_binding
  metadata {
    name        = each.key
    labels      = each.value.labels
    namespace   = each.value.namespace
    annotations = each.value.annotations
  }
  role_ref {
    kind      = each.value.role_ref.kind
    name      = each.value.role_ref.name
    api_group = "rbac.authorization.k8s.io"
  }
  dynamic "subject" {
    for_each = each.value.subject
    content {
      api_group = subject.value["api_group"]
      kind      = subject.value["kind"]
      name      = subject.value["name"]
      namespace = subject.value["namespace"]
    }
  }
  depends_on = [kubernetes_role.role, kubernetes_service_account.service_account]
}
