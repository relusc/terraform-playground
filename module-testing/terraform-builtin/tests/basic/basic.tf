terraform {
  required_providers {
    # Built-in test provider
    test = {
      source = "terraform.io/builtin/test"
    }

    google = {
      source = "hashicorp/google"
    }
  }
}

locals {
  project_id = "myproject"
  bucket_configs = {
    "gcs-vers-ew1" = {
      location           = "europe-west1"
      versioning         = true
      num_newer_versions = 5
    },
    "gcs-novers-ew4" = {
      location           = "europe-west4"
      versioning         = false
      num_newer_versions = 0 # Will be ignored anyway
    },
  }
}

module "gcs" {
  # Path to the module to test
  source         = "../.."
  project_id     = local.project_id
  bucket_configs = local.bucket_configs
}

# Use special resource test_assertions provided by built-in test provider
resource "test_assertions" "bucket_check_versioning" {
  # component gives an unique identifier for the assertions
  component = "bucket_check_versioning"

  equal "name" {
    description = "Name check for ew1 bucket with versioning enabled"
    got         = module.gcs.buckets["gcs-vers-ew1"].name
    want        = "gcs-vers-ew1"
  }

  equal "versioning_enabled" {
    description = "Check ew1 bucket if versioning is enabled"
    got         = module.gcs.buckets["gcs-vers-ew1"].versioning[0].enabled
    want        = true
  }

  equal "num_newer_versions" {
    description = "Check ew1 bucket if num_newer_version is set correctly"
    got         = tolist(module.gcs.buckets["gcs-vers-ew1"].lifecycle_rule[0].condition)[0].num_newer_versions
    want        = 5
  }
}

resource "test_assertions" "bucket_check_versioning_disabled" {
  # component gives an unique identifier for the assertions
  component = "bucket_check_versioning_disabled"

  equal "name" {
    description = "Name check for ew4 bucket with versioning disabled"
    got         = module.gcs.buckets["gcs-novers-ew4"].name
    want        = "gcs-novers-ew4"
  }

  equal "versioning_disabled" {
    description = "Check ew1 bucket if versioning is disabled"
    got         = module.gcs.buckets["gcs-novers-ew4"].versioning[0].enabled
    want        = false
  }

  equal "location" {
    description = "Check we4 bucket location"
    got         = module.gcs.buckets["gcs-novers-ew4"].location
    want        = "EUROPE-WEST4" # Location is somehow capizalized on GCP API side
  }
}
