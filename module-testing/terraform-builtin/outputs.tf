output "buckets" {
  description = "The created GCS buckets"
  value       = google_storage_bucket.this
}
