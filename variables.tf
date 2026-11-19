# AWS Region
variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
}

# Project Name
variable "project_name" {
  description = "Name of the project"
  type        = string
}

# Production VPC CIDR
variable "vpc_cidr" {
  description = "CIDR block for the production VPC"
  type        = string
}
