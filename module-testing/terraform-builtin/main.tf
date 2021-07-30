resource "google_compute_network" "this" {
  project                 = var.project_id
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "this" {
  project       = var.project_id
  for_each      = var.subnets
  name          = each.value.name
  region        = each.value.region
  network       = google_compute_network.this.name
  ip_cidr_range = each.value.cidr
  depends_on = [
    google_compute_network.this
  ]
}
