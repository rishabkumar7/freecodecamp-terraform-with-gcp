resource "google_storage_bucket" "static_site" {
  name          = "example-rishab-coffee"
  location      = "US"
  force_destroy = true
  website {
  main_page_suffix = "index.html"
  }
  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}
resource "google_storage_bucket_object" "static_site_src" {
  name   = "index.html"
  source = "../website/index.html"
  bucket = google_storage_bucket.static_site.name
}

resource "google_storage_default_object_access_control" "public_rule" {
  bucket = google_storage_bucket.static_site.name
  role   = "READER"
  entity = "allUsers"
}

# Reserve IP address
resource "google_compute_global_address" "default" {
  name = "example-ip"
}

resource "google_compute_backend_bucket" "static_site" {
  name        = "examplestaticsite"
  description = "Contains hello world"
  bucket_name = google_storage_bucket.static_site.name
}

resource "google_compute_url_map" "default" {
  name = "http-lb"

  default_service = google_compute_backend_bucket.static_site.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "path-matcher-2"
  }
  path_matcher {
    name            = "path-matcher-2"
    default_service = google_compute_backend_bucket.static_site.id

    path_rule {
      paths   = ["/love-to-fetch/*"]
      service = google_compute_backend_bucket.static_site.id
    }
  }
}

resource "google_compute_target_http_proxy" "default" {
  name    = "http-lb-proxy"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_global_forwarding_rule" "default" {
  name                  = "http-lb-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}