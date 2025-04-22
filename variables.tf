variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  default     = "us-central1"
}

variable "credential_file" {
  type        = string
  description = "Path to the service account key file"
}

variable "service_name" {
  type        = string
  description = "Name of the Cloud Run service"
}

variable "docker_image" {
  type        = string
  description = "Docker Hub image (e.g. dockerhubuser/repo:tag)"
}

variable "container_port" {
  type        = number
  default     = 8000
  description = "Container port for the Cloud Run service"
}

variable "google_api_key" {
  type        = string
  description = "Google API key for the service"
}

variable "line_channel_access_token" {
  type        = string
  description = "LINE Channel Access Token"
}

variable "line_channel_secret" {
  type        = string
  description = "LINE Channel Secret"
}

variable "cron_job" {
  type        = string
  default     = "0 9 * * *"
  description = "Cron job schedule (default: every hour)"
}

variable "gcp_docker_image" {
  type        = string
  description = "GCP Container Registry image (gcr.io/project/image:tag)"
}

variable "app_installation_id" {
  type        = number
  description = "GitHub App installation ID"
}

variable "oauth_token_secret" {
  type        = string
  description = "OAuth token secret for GitHub"
}

variable "remote_uri" {
  type        = string
  description = "Remote URI for the GitHub repository"
}

variable "repo_owner" {
  type        = string
  description = "GitHub repository owner"
}

variable "repo_name" {
  type        = string
  description = "GitHub repository name"
}

variable "repo_branch" {
  type        = string
  default     = "main"
}

variable "ar_hostname" {
  type        = string
  description = "Artifact Registry hostname"
}

variable "ar_repository" {
  type        = string
  description = "Artifact Registry repository name"
}

variable "ar_project_id" {
  type        = string
  description = "Artifact Registry project ID"
}

variable "cloudbuild_service_account" {
  type        = string
  description = "Cloud Build service account email"
}
