output "host" {
  value       = google_redis_instance.redis-instance.host
  description = "The IP address of the redis instance."
}

output "port" {
  value       = google_redis_instance.redis-instance.port
  description = "The port number of the redis instance."
}

output "password" {
  value       = google_redis_instance.redis-instance.auth_string
  description = "password for redis instance."
}
