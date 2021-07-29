variable "project_id" {
  description = "GCP project in which the resources will be deployed"
  type        = string
}

variable "vm_name" {
  description = "Name of the created VM"
  type        = string
}

variable "machine_type" {
  description = "Machine type of the GCE instance"
  type        = string
}

variable "zone" {
  description = "GCP zone in which the resources will be deployed"
  type        = string
}

variable "svc_acc_name" {
  description = "SVC account name with which the GCE instance will be running"
  type        = string
}
