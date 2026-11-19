# PHASE 1 - Production VPC outputs
output "production_vpc_id" {
  description = "ID of the NexPay production VPC"
  value       = aws_vpc.production.id
}

output "production_vpc_cidr" {
  description = "CIDR block of the production VPC"
  value       = aws_vpc.production.cidr_block
}

# PHASE 2 - Inspect subnet IDs, CIDRs, and Availability Zones
output "public_subnet_ids" {
  description = "IDs of the two public-designated subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the two private subnets"
  value       = aws_subnet.private[*].id
}

output "public_subnet_cidrs" {
  description = "CIDR blocks allocated to public subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_cidrs" {
  description = "CIDR blocks allocated to private subnets"
  value       = aws_subnet.private[*].cidr_block
}

output "subnet_availability_zones" {
  description = "The two Availability Zones used for subnet deployment"
  value       = [for subnet in aws_subnet.public : subnet.availability_zone]
}
