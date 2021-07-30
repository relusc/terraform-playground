variable "project_id" {
  description = "GCP project in which the resources will be deployed"
  type        = string
}

variable "network_name" {
  description = "Name of the created VPC"
  type        = string
}

variable "subnets" {
  description = "All subnets of the VPC"
  type = map(object({
    name   = string
    region = string
    cidr   = string
  }))
}
