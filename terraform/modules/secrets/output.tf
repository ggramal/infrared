output "gcp_secrets" {
  value = {
    for secret_obj in local.gcp_secrets :
    "${secret_obj.name}.${secret_obj.secret_name}" => merge(
      secret_obj,
      {
        gcp = module.gcp_secrets["${secret_obj.name}-${secret_obj.secret_name}"]
      }
    )
  }
  sensitive = true
}
