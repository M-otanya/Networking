# PHASE 1 - Production VPC outputs
output "production_vpc_id" {
  description = "ID of the NexPay production VPC"
  value       = aws_vpc.production.id
}

output "production_vpc_cidr" {
  description = "CIDR block of the production VPC"
  value       = aws_vpc.production.cidr_block
}

# PHASE 2 - Subnet outputs (DISABLED) — inspect subnet IDs, CIDRs, and AZs
# output "public_subnet_ids" {
#   description = "IDs of the two public-designated subnets"
#   value       = aws_subnet.public[*].id
# }
#
# output "private_subnet_ids" {
#   description = "IDs of the two private subnets"
#   value       = aws_subnet.private[*].id
# }
#
# output "public_subnet_cidrs" {
#   description = "CIDR blocks allocated to public subnets"
#   value       = aws_subnet.public[*].cidr_block
# }
#
# output "private_subnet_cidrs" {
#   description = "CIDR blocks allocated to private subnets"
#   value       = aws_subnet.private[*].cidr_block
# }
#
# output "subnet_availability_zones" {
#   description = "The two Availability Zones used for subnet deployment"
#   value       = [for subnet in aws_subnet.public : subnet.availability_zone]
# }
#
# ============================================================
# PHASE 3 - Internet and public route outputs (DISABLED)

# ============================================================
# output "internet_gateway_id" { value = aws_internet_gateway.production.id }
# output "public_route_table_id" { value = aws_route_table.public.id }

# ============================================================
# PHASE 4 - NAT and private route outputs (DISABLED)
# ============================================================
# output "nat_gateway_id" { value = aws_nat_gateway.production.id }
# output "private_route_table_id" { value = aws_route_table.private.id }

# ============================================================
# PHASE 5 - Security group identifiers (DISABLED)


# ============================================================
# output "web_security_group_id" { value = aws_security_group.web.id }
# output "app_security_group_id" { value = aws_security_group.app.id }
# output "database_security_group_id" { value = aws_security_group.database.id }

# ============================================================
# PHASE 6 - Network ACL identifiers (DISABLED)


# ============================================================
# output "public_nacl_id" { value = aws_network_acl.public.id }
# output "private_nacl_id" { value = aws_network_acl.private.id }

# ============================================================
# PHASE 7 - Web and application instance identifiers (DISABLED)


# ============================================================
# output "web_instance_ids" { value = aws_instance.web[*].id }
# output "app_instance_ids" { value = aws_instance.app[*].id }
# output "web_public_ips" { value = aws_instance.web[*].public_ip }
# output "app_private_ips" { value = aws_instance.app[*].private_ip }
