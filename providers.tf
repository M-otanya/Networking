provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "NexPay-Network"
      Environment = "lab"
      ManagedBy   = "Terraform"
    }
  }
}
