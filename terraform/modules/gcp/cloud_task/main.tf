resource "google_cloud_tasks_queue" "this" {
  name     = var.name
  location = var.location

  dynamic "rate_limits" {
    for_each = var.rate_limits == null ? {} : { "rate_limits" = var.rate_limits }
    content {
      max_concurrent_dispatches = rate_limits.value.max_concurrent_dispatches
      max_dispatches_per_second = rate_limits.value.max_dispatches_per_second
      max_burst_size            = rate_limits.value.max_burst_size
    }
  }

  dynamic "retry_config" {
    for_each = var.retry_configs == null ? {} : { "retry_configs" = var.retry_configs }
    content {
      max_attempts       = retry_config.value.max_attempts
      max_retry_duration = retry_config.value.max_retry_duration
      max_backoff        = retry_config.value.max_backoff
      min_backoff        = retry_config.value.min_backoff
      max_doublings      = retry_config.value.max_doublings
    }
  }
}

resource "google_cloud_tasks_queue_iam_binding" "binding" {
  for_each = var.iam_bindings
  location = var.location
  name     = google_cloud_tasks_queue.this.name
  role     = each.value.role
  members  = each.value.members
}
