output "cloudrun_service" {
  description = "Cloudrun service"
  value = merge(
    google_cloud_run_v2_service.this,
    {
      for neg_obj in google_compute_region_network_endpoint_group.this :
      "neg" => neg_obj
    }
  )
}
