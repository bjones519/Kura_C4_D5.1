
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "security_group_vpc_id" {
  description = "The VPC ID"
  value       = module.ssh_security_group.security_group_vpc_id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = module.ssh_security_group.security_group_id

}
output "security_group_id2" {
  description = "The ID of the http-8080 security group"
  value       = module.http_8080_security_group.security_group_id

}

output "security_group_id3" {
  description = "The ID of the http-8000 security group"
  value       = module.app_service_sg.security_group_id

}