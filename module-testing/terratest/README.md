# Module testing with terratest

This folder describes integration testing a Terraform module with [`terratest`](https://github.com/gruntwork-io/terratest). `terratest` lets you write integration tests for your IaC in [Golang](https://golang.org/).

## Module setup

The example Terraform module itself creates a simple GCE instance (see [`main.tf`](./main.tf)). Following values need to be submitted via Terraform input variables (see [`variables.tf`](./variables.tf)):

- `project_id`: GCP project in which the instance will be created
- `vm_name`: GCE instance name
- `machine_type`: The instance machine type
- `zone`: GCP zone in which the instance will be createed
- `svc_acc_mail`: Email of the service account used for running the instance

The module outputs the created instance, see [`outputs.tf`](./outputs.tf).

## Test setup

The test setup is defined in the [`test`](./test) folder.

The [`wrapper`](./test/wrapper) folder contains a wrapper Terraform module using the GCE instance module described in the section above. It also creates a `google_service_account` resource. Its email is used as `svc_acc_mail` input parameter for the GCE instance module.

The wrapper module outputs the name of the created instance and the service account email which will be reused in the actual tests.

The tests itself are written in Golang and can be found in the [`instance_test.go`](./test/instance_test.go) file. There's another file [`gcp.go`](./test/gcp.go) that creates necessary GCP API clients in order to interact with the created resources.

Documentation about what the tests actually do can be found in the Go files.

## Prerequisites

`terratest` needs a `terraform` executable file that matches the Terraform constraint defined in the [`versions.tf`](./versions.tf) file.

## Execute tests

1. Navigate to `./test`
1. Run `go get -v -d ./...` to fetch all dependencies (e.g. `terratest`) itself
1. Run `go test ./...`. Use the `-v` option for verbose/more detailed output
