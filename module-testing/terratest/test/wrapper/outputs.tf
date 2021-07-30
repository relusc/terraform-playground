output "instance_name" {
  description = "Name of the created GCE instance"
  value       = module.vm.instance.name
}

output "svc_acc_email" {
  description = "Name of the created service account"
  value       = google_service_account.this.email
}
