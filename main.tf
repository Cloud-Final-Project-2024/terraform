provider "google" {
  project = var.project_id
  region  = var.region
  credentials = file(var.credential_file)
}

locals {
  required_services = [
    "run.googleapis.com",
    "cloudscheduler.googleapis.com",
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
    "secretmanager.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudapis.googleapis.com"
  ]
}

resource "google_project_service" "required" {
  for_each           = toset(local.required_services)
  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}

resource "google_service_account" "scheduler_invoker" {
  account_id   = "scheduler-invoker"
  display_name = "Scheduler Invoker Service Account"
}

resource "google_cloud_run_service" "backend" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      service_account_name = google_service_account.scheduler_invoker.email
      containers {
        image = var.docker_image
        ports {
          container_port = var.container_port
        }
        env {
          name  = "GOOGLE_API_KEY"
          value = var.google_api_key
        }
        env {
          name  = "LINE_CHANNEL_ACCESS_TOKEN"
          value = var.line_channel_access_token
        }
        env {
          name  = "LINE_CHANNEL_SECRET"
          value = var.line_channel_secret
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "allow_all" {
  location = var.region
  service  = google_cloud_run_service.backend.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_scheduler_job" "call_broadcast" {
  name     = "${var.service_name}-broadcast-job"
  region   = var.region
  schedule = var.cron_job
  

  http_target {
    http_method = "POST"
    uri         = "${google_cloud_run_service.backend.status[0].url}/broadcast"

    oidc_token {
      service_account_email = google_service_account.scheduler_invoker.email
    }
  }

  time_zone = "Asia/Bangkok"
}

resource "google_cloudbuildv2_connection" "github-connection" {
  location = var.region
  name = "github-connection"

  github_config {
    app_installation_id = var.app_installation_id
    authorizer_credential {
      oauth_token_secret_version = var.oauth_token_secret
    }
  }
}

resource "google_cloudbuildv2_repository" "github-repository" {
  name             = var.repo_name
  parent_connection = google_cloudbuildv2_connection.github-connection.id
  remote_uri       = var.remote_uri
}

resource "google_cloudbuild_trigger" "repo-trigger" {
  name     = "repo-trigger-cicd"
  location = var.region

  repository_event_config {
    repository = google_cloudbuildv2_repository.github-repository.id
    push {
      branch = var.repo_branch
    }
  }

  substitutions = {
    _REPO_NAME        = var.repo_name
    _SERVICE_NAME     = var.service_name
    _DEPLOY_REGION    = var.region
    _AR_HOSTNAME      = var.ar_hostname
    _AR_REPOSITORY    = var.ar_repository
    _AR_PROJECT_ID    = var.ar_project_id
    _PLATFORM         = "managed"
  }

  service_account = var.cloudbuild_service_account

  filename = "cloudbuild.yaml"
}

data "google_project" "current" {}

resource "google_project_iam_member" "cloudbuild_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${data.google_project.current.number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "cloudbuild_storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${data.google_project.current.number}@cloudbuild.gserviceaccount.com"
}

resource "google_project_iam_member" "cloudbuild_builds_editor" {
    project = var.project_id
    role    = "roles/cloudbuild.builds.editor"
    member  = "serviceAccount:${data.google_project.current.number}@cloudbuild.gserviceaccount.com"
}

output "cloud_run_url" {
  value = google_cloud_run_service.backend.status[0].url
}