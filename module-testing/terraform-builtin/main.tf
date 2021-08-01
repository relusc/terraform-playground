resource "google_storage_bucket" "this" {
  for_each      = var.bucket_configs
  project       = var.project_id
  name          = each.key
  location      = each.value.location
  storage_class = "STANDARD"
  versioning {
    enabled = each.value.versioning
  }
  dynamic "lifecycle_rule" {
    for_each = each.value.versioning ? [""] : []
    content {
      condition {
        num_newer_versions = each.value.num_newer_versions
      }
      action {
        type = "Delete"
      }
    }
  }
}
