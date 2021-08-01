variable "project_id" {
  description = "GCP project in which the resources will be deployed"
  type        = string
}

variable "bucket_configs" {
  description = "GCS buckets to create"
  type = map(object({
    location           = string
    versioning         = bool
    num_newer_versions = string
  }))
}
