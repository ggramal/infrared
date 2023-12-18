resource "github_repository_deploy_key" "keys" {
  for_each   = var.deploy_keys
  title      = each.value.name
  repository = var.name
  key        = each.value.key
  read_only  = each.value.read_only
}

resource "github_actions_secret" "secrets" {
  for_each        = var.secrets
  repository      = var.name
  secret_name     = each.value.name
  plaintext_value = each.value.text_value
}
