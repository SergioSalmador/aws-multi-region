# aws-multi-region

Terraform infrastructure for two environments (`dev`, `prod`) across two AWS regions:
- Ireland (`eu-west-1`)
- Spain (`eu-south-2`)

## Repository layout

```text
bootstrap-state/
environments/
  dev/
    networking/
      ireland/
      spain/
    data/
      rds-cross-region/
  prod/
    networking/
      ireland/
      spain/
    data/
      rds-cross-region/
docs/
  architecture/
```

## Architecture diagrams

### Networking
![Networking architecture](docs/architecture/networking.png)

### Aurora Global Database + Route53
![RDS Aurora architecture](docs/architecture/rds-aurora.png)

## Network ranges (non-overlapping CIDR)

- `dev` Ireland: `10.10.0.0/16`
- `dev` Spain: `10.11.0.0/16`
- `prod` Ireland: `10.20.0.0/16`
- `prod` Spain: `10.21.0.0/16`

## What is deployed

`networking/*` stacks:
- VPC in each region using `terraform-aws-modules/vpc/aws`
- Public and private subnets in 3 AZ
- AWS Client VPN per region

`data/rds-cross-region` stacks:
- Aurora Global Database using `terraform-aws-modules/rds-aurora/aws`
- Primary cluster in Ireland and secondary cluster in Spain
- Private Route53 hosted zone associated to both VPCs
- DNS records:
- `aurora-writer.<private-zone>`
- `aurora-reader.<private-zone>`

## Deployment order

## 1) Bootstrap remote state backend

```bash
cd bootstrap-state
terraform init
terraform apply
```

Required outputs:
- `tfstate_bucket_name`
- `tfstate_lock_table_name`
- `backend_region`

## 2) Fill backend files (`backend.hcl`)

Populate:
- `environments/dev/networking/ireland/backend.hcl`
- `environments/dev/networking/spain/backend.hcl`
- `environments/prod/networking/ireland/backend.hcl`
- `environments/prod/networking/spain/backend.hcl`
- `environments/dev/data/rds-cross-region/backend.hcl`
- `environments/prod/data/rds-cross-region/backend.hcl`

## 3) Deploy networking

```bash
cd environments/dev/networking/ireland
terraform init -backend-config=backend.hcl
terraform apply

cd ../spain
terraform init -backend-config=backend.hcl
terraform apply

cd ../../../prod/networking/ireland
terraform init -backend-config=backend.hcl
terraform apply

cd ../spain
terraform init -backend-config=backend.hcl
terraform apply
```

## 4) Deploy Aurora + DNS

```bash
cd environments/dev/data/rds-cross-region
terraform init -backend-config=backend.hcl
terraform apply

cd ../../../prod/data/rds-cross-region
terraform init -backend-config=backend.hcl
terraform apply
```

Useful outputs from `data/rds-cross-region`:
- `primary_cluster_endpoint`
- `secondary_cluster_endpoint`
- `aurora_writer_dns_name`
- `aurora_reader_dns_name`
- `global_failover_command`

## Failover notes

- Aurora Global failover promotes the secondary cluster.
- If applications use Route53 writer/reader records, update DNS target if needed after failover.
