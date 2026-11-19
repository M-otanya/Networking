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

# PHASE 2 - Subnet inputs
# Defaults are compatible with the existing 10.10.0.0/16 VPC.
# For a different VPC CIDR, update these ranges before planning.
variable "public_subnet_cidrs" {
  description = "Two non-overlapping public subnet CIDRs, one per Availability Zone"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24"]

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Provide exactly two public subnet CIDR blocks."
  }
}

variable "private_subnet_cidrs" {
  description = "Two non-overlapping private subnet CIDRs, one per Availability Zone"
  type        = list(string)
  default     = ["10.10.11.0/24", "10.10.12.0/24"]

  validation {
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "Provide exactly two private subnet CIDR blocks."
  }
}
