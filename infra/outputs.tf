output "url" {
  description = "Website URL"
  value       = google_storage_bucket.static_site.self_link
}