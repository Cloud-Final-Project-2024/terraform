# 🚀 GCP Cloud Run Deployment with GitHub CI/CD (Terraform)

This Terraform project sets up a fully automated Google Cloud Run deployment pipeline using GitHub integration and Cloud Build, including scheduled Cloud Scheduler jobs.

---

## 📋 Prerequisites

Before running this Terraform script, make sure you have:

1. **A Google Cloud Project** with billing enabled.
2. **Terraform installed** (>= 1.0.0)
3. **A GCP service account key file** with the following permissions:
   - `Project Editor` or the following:
     - `roles/run.admin`
     - `roles/cloudbuild.builds.editor`
     - `roles/cloudscheduler.admin`
     - `roles/artifactregistry.admin`
     - `roles/secretmanager.admin`
4. **Cloud Build GitHub App installed & configured**
   - Get your `App Installation ID`
   - Create a **GitHub Personal Access Token** and store it in **Secret Manager**.
5. Enable the following APIs (Terraform will do this, but you can do it manually too):
   - Cloud Run (`run.googleapis.com`)
   - Cloud Scheduler (`cloudscheduler.googleapis.com`)
   - Cloud Build (`cloudbuild.googleapis.com`)
   - Artifact Registry
   - Secret Manager
   - IAM
   - Cloud Resource Manager

---

## 🧠 Required Terraform Variables

You must define these variables via a `terraform.tfvars` file or CLI flags:

```hcl
project_id                = "your-gcp-project-id"
region                    = "us-central1"
credential_file           = "path/to/service-account.json"

# Cloud Run
service_name              = "backend-service"
docker_image              = "your/image:tag"
container_port            = 8080
google_api_key            = "your-google-api-key"
line_channel_access_token = "your-line-token"
line_channel_secret       = "your-line-secret"

# Scheduler
cron_job                  = "0 9 * * *"

# GitHub Integration
app_installation_id       = 12345678
oauth_token_secret        = "projects/PROJECT_ID/secrets/github-pat-secret/versions/latest"
repo_name                 = "your-github-repo-name"
remote_uri                = "https://github.com/your-org/your-repo.git"
repo_branch               = "^main$"

# Cloud Build
ar_hostname               = "us-central1-docker.pkg.dev"
ar_repository             = "cloud-run-source-deploy"
ar_project_id             = "your-project-id"
cloudbuild_service_account = "projects/YOUR_PROJECT_ID/serviceAccounts/cloudbuild@YOUR_PROJECT_ID.iam.gserviceaccount.com"
```

## 🚀 How to Deploy
1. Clone this repo
```bash
git clone https://github.com/Cloud-Final-Project-2024/terraform.git
```

2. Initialize Terraform
    
```bash
terraform init
```
3. Preview the changes

```bash
terraform plan
```
4. Apply the configuration

```bash
make apply
```
## 📤 Outputs
cloud_run_url: The public URL of your deployed Cloud Run service.