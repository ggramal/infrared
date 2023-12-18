module "repositories" {
  source   = "./repository"
  for_each = var.repositories
  name     = each.value.name
  deploy_keys = {
    for key_name, key_obj in each.value.deploy_keys :
    key_name => {
      name      = key_obj.name
      read_only = key_obj.read_only
      key       = key_obj.create == false ? key_obj.public_key : tls_private_key.deploy_keys["${each.key}@${key_name}"].public_key_openssh
    }
  }
  secrets = each.value.secrets
}

resource "tls_private_key" "deploy_keys" {
  for_each = {
    for key in flatten(
      [
        for repo_name, repo_obj in var.repositories :
        [
          for key_name, key_obj in repo_obj.deploy_keys :
          "${repo_name}@${key_name}"
          if key_obj.create == true
        ]
      ]
    ) :
    key => {}
  }
  algorithm   = "ED25519"
  ecdsa_curve = "P521"
}
