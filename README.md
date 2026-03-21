# aws-multi-region

Infraestructura Terraform con dos entornos (`dev` y `prod`) y red separada por región.

## Estructura

```text
bootstrap-state/
environments/
  dev/
    networking/
      ireland/
      spain/
  prod/
    networking/
      ireland/
      spain/
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

## 2) Configurar backend por stack regional

Rellena estos archivos con los valores del paso anterior:
- `environments/dev/networking/ireland/backend.hcl`
- `environments/dev/networking/spain/backend.hcl`
- `environments/prod/networking/ireland/backend.hcl`
- `environments/prod/networking/spain/backend.hcl`

## 3) Desplegar cada stack regional

### Dev Irlanda

```bash
cd environments/dev/networking/ireland
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

### Dev España

```bash
cd environments/dev/networking/spain
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

### Prod Irlanda

```bash
cd environments/prod/networking/ireland
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

### Prod España

```bash
cd environments/prod/networking/spain
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```
