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

All Phase 2 Terraform declarations in `main.tf`, `variables.tf`, and `outputs.tf` are currently **fully commented out**. With the existing Phase 1 VPC declarations active, `terraform plan` should not propose subnet creation. No AWS deployment occurs merely by committing code. The public-designated subnets are not Internet-routable until the later Internet Gateway, route tables, and associations are configured. The AWS subnet's public-IP setting alone is insufficient.

The local `terraform.tfvars` file must still supply the Phase 1 values `aws_region`, `project_name`, and `vpc_cidr`; this file is deliberately excluded from Git. Phase 2 CIDRs have defaults in `variables.tf`. Change those defaults or override them locally if your architecture differs.

## Enable Phase 2 during the live lesson

1. Open `main.tf`, select the fully commented Phase 2 data source and both subnet resource blocks, and press **Ctrl+/** in VS Code to toggle the selected lines back into active HCL. Keep Phase 1 unchanged.
2. Open `variables.tf`, select and uncomment the Phase 2 `public_subnet_cidrs` and `private_subnet_cidrs` declarations.
3. Open `outputs.tf`, select and uncomment all five Phase 2 output declarations.
4. Save the three files. Do not uncomment the **instructional heading comments**; those can stay as comments. Verify that resource, variable, output, and data declarations are active before planning. The Ctrl+/ shortcut toggles comment markers on selected lines; inspect the result before continuing.

**Before enabling Phase 2**, `terraform plan` should make no changes for an unchanged Phase 1 deployment. **After enabling Phase 2**, it should propose four new subnets and preserve the VPC. Never disable earlier deployed phase resources while growing the same Terraform state.

## Phase 2 - Developer workflow (PowerShell)

```powershell
git fetch origin
git switch phase-2-subnets
terraform init
# Uncomment Phase 2 in main.tf, variables.tf and outputs.tf first.
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
