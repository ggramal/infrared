output "uris" {
  value = {
    standard     = mongodbatlas_cluster.this.connection_strings[0].standard
    standard_srv = mongodbatlas_cluster.this.connection_strings[0].standard_srv
  }
}

output "project_id" {
  value = mongodbatlas_cluster.this.project_id
}

output "name" {
  value = mongodbatlas_cluster.this.name
}

