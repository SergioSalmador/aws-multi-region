# aws-multi-region

Infraestructura Terraform con dos entornos (`dev` y `prod`), cada uno con:
- 1 VPC en Irlanda (`eu-west-1`)
- 1 VPC en España (`eu-south-2`)

Se usa el módulo:

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"
}
```

## Estructura

```text
bootstrap-state/
environments/
  dev/
    networking/
  prod/
    networking/
```

## CIDRs (sin solape)

- `dev`:
  - Irlanda: `10.10.0.0/16`
  - España: `10.11.0.0/16`
- `prod`:
  - Irlanda: `10.20.0.0/16`
  - España: `10.21.0.0/16`

## 1) Crear backend remoto (S3 + DynamoDB)

```bash
cd bootstrap-state
terraform init
terraform apply
```

Obtén los outputs:
- `tfstate_bucket_name`
- `tfstate_lock_table_name`
- `backend_region`

## 2) Configurar backend por entorno

Rellena estos archivos con los valores del paso anterior:
- `environments/dev/networking/backend.hcl`
- `environments/prod/networking/backend.hcl`

## 3) Desplegar entorno dev

```bash
cd environments/dev/networking
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

## 4) Desplegar entorno prod

```bash
cd environments/prod/networking
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```
