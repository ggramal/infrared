output "user_name" {
  value = mongodbatlas_database_user.this.username
}

output "password" {
  value = mongodbatlas_database_user.this.password
}
