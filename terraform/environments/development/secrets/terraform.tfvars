company = {
  domain = "exampleco.com"
  name   = "exampleco"
}

gcp_projects = {
  int = {
    name         = "exampleco-internal"
    env_name     = "internal"
    region       = "europe-west2"
    default_zone = "europe-west2-b"
    multi_region = "EUROPE"
    gcr_region   = "EU"
  }
  dev = {
    name         = "exampleco-development"
    env_name     = "development"
    region       = "europe-west2"
    default_zone = "europe-west2-a"
    multi_region = "EUROPE"
    gcr_region   = "EU"
  }
  prd = {
    name         = "exampleco-production"
    env_name     = "production"
    region       = "europe-west2"
    default_zone = "europe-west2-c"
    multi_region = "EUROPE"
    gcr_region   = "EU"
  }
}
