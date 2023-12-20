resource "google_cloud_scheduler_job" "this" {
  name             = var.name
  description      = var.description
  time_zone        = var.timezone
  schedule         = var.schedule
  paused           = var.paused
  attempt_deadline = var.attempt_deadline

  dynamic "http_target" {
    for_each = var.http_target == null ? {} : { "http_target" = var.http_target }
    content {
      uri         = http_target.value.uri
      http_method = http_target.value.http_method
      body        = http_target.value.body
      headers     = http_target.value.headers
    }
  }

  dynamic "retry_config" {
    for_each = var.retry_configs == null ? {} : { "retry_configs" = var.retry_configs }
    content {
      retry_count          = retry_configs.value.retry_count
      max_retry_duration   = retry_configs.value.max_retry_duration
      max_backoff_duration = retry_configs.value.max_backoff_duration
      min_backoff_duration = retry_configs.value.min_backoff_duration
      max_doublings        = retry_configs.value.max_doublings
    }
  }

}
