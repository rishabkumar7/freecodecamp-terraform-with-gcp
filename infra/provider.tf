# GCP provider

provider "google" {
  credentials  = file(var.gcp_svc_key)
  project      = var.gcp_project
  region       = var.gcp_region
}

# GCP beta provider
provider "google-beta" {
  credentials  = file(var.gcp_svc_key)
  project      = var.gcp_project
  region       = var.gcp_region
}