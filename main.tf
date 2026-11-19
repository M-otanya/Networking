# ============================================================
# PHASE 1 - Existing production VPC (preserved)
# ============================================================
resource "aws_vpc" "production" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-production-vpc"
  }
}

# ============================================================
# PHASE 2 - Public and private subnet segmentation (DISABLED)
# Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
# ============================================================
# To activate: select the Phase 2 block, then Ctrl+/ in VS Code.
# ============================================================

# # Discover two currently available Availability Zones in the AWS region.
# # The AWS account determines which zone names are returned.
# data "aws_availability_zones" "available" {
#   state = "available"
# }
#
# # Create one public-designated subnet in each of the first two AZs.
# # map_public_ip_on_launch does NOT make a subnet publicly routed.
# # An Internet Gateway and appropriate route table are added later.
# resource "aws_subnet" "public" {
#   count                   = length(var.public_subnet_cidrs)
#   vpc_id                  = aws_vpc.production.id
#   cidr_block              = var.public_subnet_cidrs[count.index]
#   availability_zone       = data.aws_availability_zones.available.names[count.index]
#   map_public_ip_on_launch = true
#
#   tags = {
#     Name = "${var.project_name}-public-subnet-${count.index + 1}"
#     Tier = "public"
#   }
# }
#
# # Create one private subnet in each of the first two AZs.
# # No automatic public IPs; private outbound routing is a later phase.
# resource "aws_subnet" "private" {
#   count                   = length(var.private_subnet_cidrs)
#   vpc_id                  = aws_vpc.production.id
#   cidr_block              = var.private_subnet_cidrs[count.index]
#   availability_zone       = data.aws_availability_zones.available.names[count.index]
#   map_public_ip_on_launch = false
#
#   tags = {
#     Name = "${var.project_name}-private-subnet-${count.index + 1}"
#     Tier = "private"
#   }
# }
#