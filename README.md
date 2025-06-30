# 📦 AWS Infrastructure Boilerplate

A production-ready, modular, and scalable cloud infrastructure setup using **Terraform**, **AWS**, and **GitHub Actions**. It provisions the entire cloud stack — networking, compute, storage, database, secrets, and CI/CD — with a clean module-based structure.

---

## 🚀 Features
- Modular **Terraform** architecture
- Infrastructure provisioning with **VPC, ECS, ALB, S3, RDS, Secrets Manager**
- **Environment-specific configs** (dev/prod)
- **CI/CD with GitHub Actions** for both infra and app
- Secure secrets handling using **AWS Secrets Manager**

---

## 🗂️ Project Structure

```bash
.
├── terraform/
│   ├── modules/                # Reusable Terraform modules
│   │   ├── network/            # VPC, Subnets, SGs, NAT, IGW
│   │   ├── compute/            # ECS, ALB, Task Def, Service
│   │   ├── storage/            # S3 buckets
│   │   ├── database/           # RDS PostgreSQL
│   │   └── secrets/            # Secrets Manager
│   └── environments/
│       ├── dev/                # Dev-specific infra config
│       │   ├── main.tf
│       │   └── terraform.tfvars
│       └── prod/               # Prod-specific infra config
├── app/                        # Your application code (e.g., Node.js)
├── ci-cd/
│   └── github-actions/
│       ├── deploy-infra.yml    # CI pipeline for infra
│       └── deploy-app.yml      # CI pipeline for app
└── .gitignore
```

---

## ⚙️ Prerequisites
- AWS account
- AWS CLI configured locally
- Terraform CLI (v1.6+)
- GitHub repository with secrets:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`

---

## 🛠️ Setup Instructions

### 1. Clone and Configure
```bash
git clone https://github.com/your-repo/cloud-infra-boilerplate.git
cd cloud-infra-boilerplate
```

### 2. Initialize Terraform
```bash
cd terraform/environments/dev
terraform init
```

### 3. Set Secrets in `terraform.tfvars` (🚫 Don't push this file!)
Create `terraform/environments/dev/terraform.tfvars`:
```hcl
db_password = "YourStrongPassword123"
```

### 4. Apply Infra
```bash
terraform apply -auto-approve
```

---

## 🤖 CI/CD Pipelines (GitHub Actions)

### 🔹 `deploy-infra.yml`
- Triggered on push to `main` in `terraform/**`
- Runs Terraform: init → plan → apply


### GitHub Setup:
- Add secrets in **GitHub → Settings → Secrets → Actions**:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`

---

## 🔐 Secrets Management
Secrets are stored securely in **AWS Secrets Manager** and dynamically fetched into Terraform using:
```hcl
data "aws_secretsmanager_secret_version" "db" {
  secret_id = module.secrets.secret_name
}
```

Then passed into modules securely:
```hcl
db_password = jsondecode(data.aws_secretsmanager_secret_version.db.secret_string)["password"]
```

---

## 📌 Notes
- Use `prod/` folder for production-specific config
- All secret values must be excluded from Git using `.gitignore`
- You can extend modules (e.g., monitoring, logging, backup)

---

