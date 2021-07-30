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
  project_id   = "myproject"
  network_name = "test-vpc"
  subnets = {
    "sub-ew1" = {
      name   = "sub-ew1"
      region = "europe-west1"
      cidr   = "10.1.0.0/20"
    },
    "sub-ew4" = {
      name   = "sub-ew4"
      region = "europe-west4"
      cidr   = "10.3.0.0/20"
    },
  }
}

module "network" {
  # Path to the module to test
  source       = "../.."
  project_id   = local.project_id
  network_name = local.network_name
  subnets      = local.subnets
}

# Use data resource to check if VPC network exists
data "google_compute_network" "this" {
  project = local.project_id
  name    = module.network.network.name

  depends_on = [
    module.network
  ]
}

# Use special resource test_assertions provided by built-in test provider
resource "test_assertions" "vpc_check" {
  # component gives an unique identifier for the assertions
  component = "vpc_check"

  equal "name" {
    description = "VPC name check"
    got         = data.google_compute_network.this.name
    want        = "test-vpc"
  }

  equal "amount_of_subnets" {
    description = "VPC check amount of subnets"
    got         = length(data.google_compute_network.this.subnetworks_self_links)
    want        = length(local.subnets)
  }
}
