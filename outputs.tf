# Production VPC ID
output "production_vpc_id" {
  description = "ID of the NexPay production VPC"
  value       = aws_vpc.production.id
}

# Production VPC CIDR Block
output "production_vpc_cidr" {
  description = "CIDR block of the production VPC"
  value       = aws_vpc.production.cidr_block
}
