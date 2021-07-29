// Creates a simple GCE instance
resource "google_compute_instance" "this" {
  project      = var.project_id
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["terra", "test"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    terra = "test"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    email  = var.svc_acc_mail
    scopes = ["cloud-platform"]
  }
}
