# PHASE 1 - AWS provider and production VPC inputs
variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the production VPC"
  type        = string
}

# PHASE 2 - Subnet inputs (DISABLED)
# Defaults are compatible with the existing 10.10.0.0/16 VPC.
# For a different VPC CIDR, update these ranges before planning.
# variable "public_subnet_cidrs" {
#   description = "Two non-overlapping public subnet CIDRs, one per Availability Zone"
#   type        = list(string)
#   default     = ["10.10.1.0/24", "10.10.2.0/24"]
#
#   validation {
#     condition     = length(var.public_subnet_cidrs) == 2
#     error_message = "Provide exactly two public subnet CIDR blocks."
#   }
# }
#
# variable "private_subnet_cidrs" {
#   description = "Two non-overlapping private subnet CIDRs, one per Availability Zone"
#   type        = list(string)
#   default     = ["10.10.11.0/24", "10.10.12.0/24"]
#
#   validation {
#     condition     = length(var.private_subnet_cidrs) == 2
#     error_message = "Provide exactly two private subnet CIDR blocks."
#   }
# }
#

# ============================================================
# PHASE 3 - Public internet routing (DISABLED)
# Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
# The existing Phase 3 route uses a hardcoded destination.
# Use this optional input when refactoring that resource.
# ============================================================
# variable "internet_route_cidr" {
#   description = "Default destination for internet-bound IPv4 traffic"
#   type        = string
#   default     = "0.0.0.0/0"
# }

# ============================================================
# PHASE 4 - NAT and private outbound routing (DISABLED)
# Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
# Current Phase 4 uses one NAT Gateway. The toggles below are
# intended for a later multi-AZ and cost-control refactor.
# ============================================================
# variable "enable_nat_gateway" {
#   description = "Whether private subnet outbound internet access uses NAT"
#   type        = bool
#   default     = true
# }
#
# variable "nat_gateway_per_az" {
#   description = "Deploy one NAT Gateway per AZ for resilience when implemented"
#   type        = bool
#   default     = false
# }

# ============================================================
# PHASE 5 - Security groups and application traffic (DISABLED)
# Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# These inputs will replace fixed ports in the SG configuration.
# ============================================================
# variable "web_port" {
#   description = "HTTP listening port for the teaching web tier"
#   type        = number
#   default     = 80
# }
#
# variable "app_port" {
#   description = "Listening port for the private application tier"
#   type        = number
#   default     = 8080
# }
#
# variable "database_port" {
#   description = "Port the application can use to reach PostgreSQL"
#   type        = number
#   default     = 5432
# }

# ============================================================
# PHASE 6 - Network ACL design (DISABLED)
# Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl
# The current baseline ACLs allow all traffic. Apply stricter
# CIDRs only together with the required return/ephemeral ports.
# ============================================================
# variable "approved_management_cidrs" {
#   description = "Authorized administrator IPv4 CIDRs for future restricted access"
#   type        = list(string)
#   default     = []
# }

# ============================================================
# PHASE 7 - EC2 launch templates and instances (DISABLED)
# Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template
# The Phase 7 launch templates already reference this input.
# ============================================================
# variable "ec2_instance_type" {
#   description = "Instance size for lab web and application servers"
#   type        = string
#   default     = "t3.micro"
# }

# ============================================================
# FUTURE PHASE - Isolated database subnet and RDS (DISABLED)
# Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
# Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
# Reserved CIDRs do not overlap the existing four subnets.
# ============================================================
# variable "database_subnet_cidrs" {
#   description = "Isolated database subnet CIDRs, one in each AZ"
#   type        = list(string)
#   default     = ["10.10.21.0/24", "10.10.22.0/24"]
# }
#
# variable "db_instance_class" {
#   description = "RDS instance class; verify pricing before deployment"
#   type        = string
#   default     = "db.t3.micro"
# }
#
# variable "db_multi_az" {
#   description = "Whether the database should have a standby in a second AZ"
#   type        = bool
#   default     = false
# }

# ============================================================
# FUTURE PHASE - Application Load Balancer (DISABLED)
# Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
# Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
# ============================================================
# variable "alb_listener_port" {
#   description = "Initial ALB listener port; use HTTPS for production"
#   type        = number
#   default     = 80
# }
#
# variable "alb_health_check_path" {
#   description = "HTTP path used by ALB target health checks"
#   type        = string
#   default     = "/"
# }

# ============================================================
# FUTURE PHASE - Multi-VPC hub-and-spoke connectivity (DISABLED)
# Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway
# These CIDRs must not overlap the production VPC.
# ============================================================
# variable "development_vpc_cidr" {
#   description = "Address space for the development VPC"
#   type        = string
#   default     = "10.20.0.0/16"
# }
#
# variable "shared_services_vpc_cidr" {
#   description = "Address space for the shared-services VPC"
#   type        = string
#   default     = "10.30.0.0/16"
# }

# ============================================================
# FUTURE PHASE - VPC endpoint and network monitoring (DISABLED)
# Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint
# Registry: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log
# ============================================================
# variable "enable_vpc_endpoints" {
#   description = "Enable selected AWS service VPC endpoints when implemented"
#   type        = bool
#   default     = false
# }
#
# variable "vpc_flow_log_retention_days" {
#   description = "CloudWatch log retention for VPC Flow Logs"
#   type        = number
#   default     = 7
# }
