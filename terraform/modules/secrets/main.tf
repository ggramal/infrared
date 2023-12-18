locals {
  gcp_secrets_imported = flatten(
    [
      for secret_name, secret_obj in var.secrets :
      [
        for secret in secret_obj.secrets_to_import :
        {
          secret_name    = secret
          secret_data    = module.import_secrets[secret_name].secrets[secret]
          annotations    = secret_obj.annotations
          labels         = secret_obj.labels
          name           = secret_obj.name
          base64_secrets = secret_obj.base64_secrets
          iam_roles      = secret_obj.gcp.iam_roles
          kms_key        = secret_obj.gcp.kms_key
        }
      ]
      if secret_obj.gcp.enabled == true && length(secret_obj.secrets_to_import) > 0
    ]
  )
  gcp_secrets_data = flatten(
    [
      for secret_name, secret_obj in var.secrets :
      [
        for secret_name, secret_data in secret_obj.secrets_data :
        {
          secret_name    = secret_name
          secret_data    = secret_data
          annotations    = secret_obj.annotations
          labels         = secret_obj.labels
          name           = secret_obj.name
          base64_secrets = secret_obj.base64_secrets
          iam_roles      = secret_obj.gcp.iam_roles
          kms_key        = secret_obj.gcp.kms_key
        }
      ]
      if secret_obj.gcp.enabled == true && length(keys(secret_obj.secrets_data)) > 0
    ]
  )

  k8s_secrets_data = [
    for secret_name, secret_obj in var.secrets :
    {
      secret_name = secret_name
      name        = secret_obj.name
      annotations = secret_obj.annotations
      labels      = secret_obj.labels
      namespace   = secret_obj.k8s.namespace
      secret_data = secret_obj.secrets_data
    }
    if secret_obj.k8s.enabled == true && length(keys(secret_obj.secrets_data)) > 0
  ]

  k8s_secrets_imported = [
    for secret_name, secret_obj in var.secrets :
    {
      secret_name = secret_name
      name        = secret_obj.name
      annotations = secret_obj.annotations
      labels      = secret_obj.labels
      namespace   = secret_obj.k8s.namespace
      secret_data = {
        for secretname in secret_obj.secrets_to_import :
        secretname => module.import_secrets[secret_name].secrets[secretname]
      }
    }
    if secret_obj.k8s.enabled == true && length(secret_obj.secrets_to_import) > 0
  ]

  k8s_secrets_from_other_secrets = [
    for secret_name, secret_obj in var.secrets :
    {
      secret_name = secret_name
      name        = secret_obj.name
      annotations = secret_obj.annotations
      labels      = secret_obj.labels
      namespace   = secret_obj.k8s.namespace
      secret_data = module.import_secrets[secret_obj.secrets_from_other_secret].secrets
    }
    if secret_obj.k8s.enabled == true && secret_obj.secrets_from_other_secret != null
  ]
  gcp_secrets = concat(
    local.gcp_secrets_data,
    local.gcp_secrets_imported
  )
  k8s_secrets = concat(
    local.k8s_secrets_imported,
    local.k8s_secrets_from_other_secrets,
    local.k8s_secrets_data
  )

  all_secrets = concat(
    local.gcp_secrets,
    local.k8s_secrets
  )
}

module "import_secrets" {
  source = "./import_secrets"
  for_each = {
    for secret_name, secret_obj in var.secrets :
    secret_name => secret_obj
    if length(secret_obj.secrets_to_import) > 0
  }
  secrets = each.value.secrets_to_import
}

module "gcp_secrets" {
  source = "../gcp/secret"
  for_each = {
    for secret_obj in local.gcp_secrets :
    "${secret_obj.name}-${secret_obj.secret_name}" => secret_obj
  }
  annotations = each.value.annotations
  labels      = each.value.labels
  name        = each.key
  is_base64   = each.value.base64_secrets
  iam_roles   = each.value.iam_roles
  kms_key     = each.value.kms_key
  secret      = each.value.secret_data
}


module "k8s_secrets" {
  source = "../k8s/secret"
  for_each = {
    for secret_obj in local.k8s_secrets :
    "${secret_obj.secret_name}.${secret_obj.namespace}" => secret_obj
  }
  annotations = each.value.annotations
  labels      = each.value.labels
  name        = each.value.name
  data        = each.value.secret_data
  namespace   = each.value.namespace
}
