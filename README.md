# NexPay Networking with Terraform

## Phase 1 - Production VPC

The existing production VPC is defined in `main.tf` and uses the `vpc_cidr` input. Existing Terraform state must remain local or in an explicitly configured secure backend, never in GitHub.

## Phase 2 - Subnet segmentation

Adds four subnets to the existing VPC using the first two available Availability Zones in the configured AWS region.

| Subnet | CIDR (default) | Intended role |
| --- | --- | --- |
| Public 1 | 10.10.1.0/24 | Public tier, AZ 1 |
| Public 2 | 10.10.2.0/24 | Public tier, AZ 2 |
| Private 1 | 10.10.11.0/24 | Private tier, AZ 1 |
| Private 2 | 10.10.12.0/24 | Private tier, AZ 2 |

Terraform code is active but annotated with `PHASE 2` comments. **No AWS deployment occurs merely by committing the code.** The public-designated subnets are not Internet-routable until the later Internet Gateway, route tables, and associations are configured. The AWS subnet's public-IP setting alone is insufficient.

The local `terraform.tfvars` file must still supply the Phase 1 values `aws_region`, `project_name`, and `vpc_cidr`; this file is deliberately excluded from Git. Phase 2 CIDRs have defaults in `variables.tf`. Change those defaults or override them locally if your architecture differs.

## Phase 2 - Developer workflow (PowerShell)

```powershell
git fetch origin
git switch phase-2-subnets
terraform init
terraform fmt -check
terraform validate
terraform plan -out=phase2.tfplan
terraform show phase2.tfplan
terraform apply phase2.tfplan
terraform output public_subnet_ids
terraform output private_subnet_ids
terraform output subnet_availability_zones
terraform state list
```

Review `terraform plan` carefully: the expected infrastructure change is four new `aws_subnet` resources while preserving the existing `aws_vpc.production`. Do not apply if the plan proposes replacing or destroying the VPC.

Inspect AWS after apply (requires AWS CLI credentials):

```powershell
$vpcId = terraform output -raw production_vpc_id
aws ec2 describe-subnets --region us-east-1 --filters "Name=vpc-id,Values=$vpcId" --query "Subnets[*].[SubnetId,CidrBlock,AvailabilityZone,MapPublicIpOnLaunch]" --output table
```

## Official Terraform Registry sources

- [AWS subnet resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)
- [AWS Availability Zones data source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones)
