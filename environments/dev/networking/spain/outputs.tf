output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "client_vpn_endpoint_id" {
  value = try(module.ec2_client_vpn[0].endpoint_id, null)
}

output "client_vpn_dns_name" {
  value = try(module.ec2_client_vpn[0].dns_name, null)
}
