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
# ============================================================
# PHASE 3 - Internet Gateway and public routing (DISABLED)
# Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
# Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
# Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
# ============================================================
# # Connect the existing VPC to an Internet Gateway.
# resource "aws_internet_gateway" "production" {
#   vpc_id = aws_vpc.production.id
#   tags = { Name = "${var.project_name}-igw" }
# }
#
# # Create one public route table with an Internet default route.
# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.production.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.production.id
#   }
#   tags = { Name = "${var.project_name}-public-rt" }
# }
#
# # Associate both public subnets with the public route table.
# resource "aws_route_table_association" "public" {
#   count          = length(aws_subnet.public)
#   subnet_id      = aws_subnet.public[count.index].id
#   route_table_id = aws_route_table.public.id
# }

# ============================================================
# PHASE 4 - NAT Gateway and private routing (DISABLED)
# Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
# Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
# ============================================================
# # Allocate one Elastic IP for the NAT Gateway; charges may apply.
# resource "aws_eip" "nat" {
#   domain = "vpc"
#   tags   = { Name = "${var.project_name}-nat-eip" }
# }
#
# # Place the NAT Gateway in the first public subnet.
# # A single NAT Gateway is lower-cost but not AZ-resilient.
# resource "aws_nat_gateway" "production" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.public[0].id
#   depends_on    = [aws_internet_gateway.production]
#   tags          = { Name = "${var.project_name}-nat" }
# }
#
# # Add private default routing via NAT, for both private subnets.
# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.production.id
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.production.id
#   }
#   tags = { Name = "${var.project_name}-private-rt" }
# }
#
# resource "aws_route_table_association" "private" {
#   count          = length(aws_subnet.private)
#   subnet_id      = aws_subnet.private[count.index].id
#   route_table_id = aws_route_table.private.id
# }

# ============================================================
# PHASE 5 - Three-tier security groups (DISABLED)
# Uncomment only when demonstrating this phase. Keep previous phases active.
# Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# ============================================================
# # Public web tier: permit HTTP from the internet; all outbound.
# resource "aws_security_group" "web" {
#   name_prefix = "${var.project_name}-web-"
#   description = "Public web tier HTTP ingress"
#   vpc_id      = aws_vpc.production.id
#   ingress {
#     description = "HTTP"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = { Name = "${var.project_name}-web-sg" }
# }
#
# # Private application tier: only allow TCP 8080 from web security group.
# resource "aws_security_group" "app" {
#   name_prefix = "${var.project_name}-app-"
#   description = "Private application tier"
#   vpc_id      = aws_vpc.production.id
#   ingress {
#     description     = "Application traffic from web"
#     from_port       = 8080
#     to_port         = 8080
#     protocol        = "tcp"
#     security_groups = [aws_security_group.web.id]
#   }
#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = { Name = "${var.project_name}-app-sg" }
# }
#
# # Database boundary: allow PostgreSQL only from the application tier.
# # A database instance is NOT deployed in this phase.
# resource "aws_security_group" "database" {
#   name_prefix = "${var.project_name}-db-"
#   description = "Database boundary for future resources"
#   vpc_id      = aws_vpc.production.id
#   ingress {
#     description     = "PostgreSQL from application tier"
#     from_port       = 5432
#     to_port         = 5432
#     protocol        = "tcp"
#     security_groups = [aws_security_group.app.id]
#   }
#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = { Name = "${var.project_name}-database-sg" }
# }

# ============================================================
# PHASE 6 - Public and private network ACLs (DISABLED)
# Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl
# ============================================================
# # Explicit subnet NACLs for inspection and future rule hardening.
# # Teaching baseline: ALLOW ALL in and out; security groups remain restrictive.
# # NACLs are stateless. Restrict these only after testing ephemeral-port flows.
# resource "aws_network_acl" "public" {
#   vpc_id     = aws_vpc.production.id
#   subnet_ids = aws_subnet.public[*].id
#   ingress {
#     rule_no    = 100
#     protocol   = "-1"
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 0
#     to_port    = 0
#   }
#   egress {
#     rule_no    = 100
#     protocol   = "-1"
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 0
#     to_port    = 0
#   }
#   tags = { Name = "${var.project_name}-public-nacl" }
# }
#
# resource "aws_network_acl" "private" {
#   vpc_id     = aws_vpc.production.id
#   subnet_ids = aws_subnet.private[*].id
#   ingress {
#     rule_no    = 100
#     protocol   = "-1"
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 0
#     to_port    = 0
#   }
#   egress {
#     rule_no    = 100
#     protocol   = "-1"
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 0
#     to_port    = 0
#   }
#   tags = { Name = "${var.project_name}-private-nacl" }
# }

# ============================================================
# PHASE 7 - EC2 launch templates and web/app instances (DISABLED)
# Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template
# Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter
# ============================================================
# # Resolve a current Amazon Linux 2023 AMI via AWS public SSM parameter.
# data "aws_ssm_parameter" "al2023_ami" {
#   name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
# }
#
# # Define reusable web instance configuration.
# resource "aws_launch_template" "web" {
#   name_prefix   = "${var.project_name}-web-"
#   image_id      = data.aws_ssm_parameter.al2023_ami.value
#   instance_type = var.ec2_instance_type
#   vpc_security_group_ids = [aws_security_group.web.id]
#   user_data = base64encode(<<-EOF
#     #!/bin/bash
#     dnf install -y python3
#     mkdir -p /opt/nexpay
#     echo 'NexPay web tier' > /opt/nexpay/index.html
#     cd /opt/nexpay
#     nohup python3 -m http.server 80 --bind 0.0.0.0 >/var/log/nexpay-web.log 2>&1 &
#   EOF
#   )
#   tag_specifications {
#     resource_type = "instance"
#     tags = { Tier = "web", Project = var.project_name }
#   }
# }
#
# # Define reusable private application instance configuration.
# resource "aws_launch_template" "app" {
#   name_prefix   = "${var.project_name}-app-"
#   image_id      = data.aws_ssm_parameter.al2023_ami.value
#   instance_type = var.ec2_instance_type
#   vpc_security_group_ids = [aws_security_group.app.id]
#   user_data = base64encode(<<-EOF
#     #!/bin/bash
#     dnf install -y python3
#     mkdir -p /opt/nexpay
#     echo 'NexPay application tier' > /opt/nexpay/index.html
#     cd /opt/nexpay
#     nohup python3 -m http.server 8080 --bind 0.0.0.0 >/var/log/nexpay-app.log 2>&1 &
#   EOF
#   )
#   tag_specifications {
#     resource_type = "instance"
#     tags = { Tier = "app", Project = var.project_name }
#   }
# }
#
# # Launch one EC2 web server per public subnet.
# resource "aws_instance" "web" {
#   count     = length(aws_subnet.public)
#   subnet_id = aws_subnet.public[count.index].id
#   launch_template {
#     id      = aws_launch_template.web.id
#     version = "$Latest"
#   }
#   tags = { Name = "${var.project_name}-web-${count.index + 1}" }
# }
#
# # Launch one EC2 application server per private subnet.
# resource "aws_instance" "app" {
#   count     = length(aws_subnet.private)
#   subnet_id = aws_subnet.private[count.index].id
#   launch_template {
#     id      = aws_launch_template.app.id
#     version = "$Latest"
#   }
#   tags = { Name = "${var.project_name}-app-${count.index + 1}" }
# }
