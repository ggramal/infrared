output "user_password" {
  value = {
    for user, password_obj in random_password.passwords :
    user => password_obj.result
  }
}
