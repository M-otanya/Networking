# NexPay — AWS Networking Infrastructure

NexPay is a practical infrastructure-as-code project that demonstrates how to build the networking foundation for a secure, scalable, three-tier application on Amazon Web Services using Terraform.

The project addresses a common cloud architecture challenge: application components must communicate reliably without exposing internal services or databases directly to the public internet. It provides a repeatable way to provision a dedicated virtual network, separate internet-facing and internal workloads, control network traffic, and deploy compute resources within clearly defined security boundaries.

The architecture uses an Amazon VPC across multiple Availability Zones, public and private subnets, an Internet Gateway, outbound connectivity for private workloads through NAT, route tables, security groups, network access control lists, and EC2 launch templates. The web tier is internet-facing, the application tier runs on private subnets, and the database tier is represented by a restricted network security boundary.

Terraform enables the infrastructure to be reviewed, version-controlled, reproduced, and maintained consistently. The repository is also a hands-on teaching reference for AWS networking, Terraform configuration, and operational verification.

**Technology:** AWS, Terraform, Amazon VPC, EC2, AWS networking and GitHub.

**Security and cost:** Do not commit credentials, `terraform.tfvars`, Terraform state or saved plan files. AWS networking and compute services, including NAT Gateways, public IPv4 addresses and EC2 instances, may incur charges. Review proposed changes before applying them.
