output "instance_name" {
  description = "Name of the created GCE instance"
  value       = module.vm.instance.name
}
