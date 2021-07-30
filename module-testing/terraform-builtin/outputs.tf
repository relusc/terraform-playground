output "network" {
  description = "The created GCP VPC network"
  value       = google_compute_network.this
}
