locals {
  secrets = merge(
    local.prometheus,
    local.postgres,
  )
}
