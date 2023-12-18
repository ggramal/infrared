locals {
  secrets = merge(
    local.prometheus,
    local.postgres,
    local.redis,
  )
}
