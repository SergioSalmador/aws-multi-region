output "vpc_id" {
  value = module.vpc.vpc_id
}

output "client_vpn_endpoint_id" {
  value = try(module.ec2_client_vpn[0].endpoint_id, null)
}

output "client_vpn_dns_name" {
  value = try(module.ec2_client_vpn[0].dns_name, null)
}
