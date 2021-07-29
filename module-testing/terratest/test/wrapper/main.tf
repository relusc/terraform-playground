// Test resource: service account
resource "google_service_account" "this" {
  project      = var.project_id
  account_id   = var.svc_acc_name
  display_name = "Terratest test service account"
}

// Creating the GCE instance
module "vm" {
  source       = "../../"
  project_id   = var.project_id
  vm_name      = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone
  svc_acc_mail = google_service_account.this.email
}
