resource "google_cloud_tasks_queue" "this" {
  name = var.name
  location = var.location

  dynamic {
    for_each = var.rate_limits == null ? {} : { "rate_limits" = var.rate_limits }
    rate_limits {
      max_concurrent_dispatches = rate_limits.value.max_concurrent_dispatches
      max_dispatches_per_second = rate_limits.value.max_dispatches_per_second
      max_burst_size = rate_limits.value.max_burst_size
    }
  }

  dynamic {
    for_each = var.retry_configs == null ? {} : { "retry_configs" = var.retry_configs } 
    retry_config {
      max_attempts       = retry_configs.value.max_attempts
      max_retry_duration = retry_configs.value.max_retry_duration
      max_backoff        = retry_configs.value.max_backoff
      min_backoff        = retry_configs.value.min_backoff
      max_doublings      = retry_configs.value.max_doublings
    }
  }
}



