# Module testing with 'terraform test'

This folder describes integration testing a Terraform module with the builtin `terraform test` command (see <https://www.terraform.io/docs/language/modules/testing-experiment.html>) that has been available since the release of Terraform 0.15. The tests will be defined in HCL `.tf` files.

## Module setup

The example Terraform module itself creates simple GCS buckets (see [`main.tf`](./main.tf)). Following values need to be submitted via Terraform input variables (see [`variables.tf`](./variables.tf)):

- `project_id`: GCP project in which the instance will be created
- `bucket_configs`: All buckets that will be created with different config parameters

The module outputs the created GCS buckets, see [`outputs.tf`](./outputs.tf).

## Test setup

The test setup is defined in the [`tests`](./tests) folder (this name is necessary, otherwise the `test` command does not find the tests).

All test suites have to reside in own subfolders, in this case the [`basic`](./tests/basic) folder. Inside the subfolder the tests are written in `.tf` files. They use a special built-in test provider that exposes a special resource that can be used for test assertions. More details can be found in the [test file](./tests/basic/basic.tf) itself.

## Test execution

1. Be sure to be on the root level of this example module
2. Run `terraform test`. That's it!
