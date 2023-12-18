output "secrets" {
  value = {
    for name, obj in secret_resource.secrets :
    name => obj.value
  }
}
