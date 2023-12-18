# Terraform gke
Definition of gke 

## Initial configuration steps

1. `../gcp/` `state` must be fully applied


## Running locally

You need to
1. Install `gcloud` cli
2. Set credentials by one of two ways:
    - Run `export GOOGLE_CREDENTIALS="<path>"`
    - Run `gcloud auth application-default login`
3. Run `terraform init`
4. Run `terraform plan/apply`


## Resources created
* namespaces
