# Terraform gcp
Definition of gcp env

## Initial configuration steps

1. Navigate in gcp console to `Compute engine` if `Enable API` screen apears click `enable`


## Running locally

You need to
1. Install `gcloud` cli
2. Set credentials by one of two ways:
    - Run `export GOOGLE_CREDENTIALS="<path>"`
    - Run `gcloud auth application-default login`
3. Run `terraform init`
4. Run `terraform plan/apply`


## Resources created
* gke
  * main gke
* gcs buckets
  * thanos bucket to store metrics
* vpc 
  * nat gws
  * routers
  * subnets
* iam 
 * gke node service accounts and role
 * thanos service account
 * service account to pull/push images to gcr 
