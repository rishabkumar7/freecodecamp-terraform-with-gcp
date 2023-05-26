output "url" {
  description = "Website URL"
  value       = google_compute_url_map.website.self_link
}