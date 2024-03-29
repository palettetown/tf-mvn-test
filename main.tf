#resource "google_project_iam_member" "artifact_registry_service_account" {
#  project = "my-second-project-418213"
#  role    = "roles/artifactregistry.serviceAgent"
#  member  = "serviceAccount:ksyservacc@my-second-project-418213.iam.gserviceaccount.com"
#}
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.21.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = "my-second-project-418213"
  region = "northamerica-northeast2"
}

resource "google_service_account" "artifact_registry" {
  account_id   = "artifact-registry-sa"
  display_name = "Artifact Registry Service Account"
}

resource "google_artifact_registry_repository" "docker_repo" {
  provider      = google
  location      = "NORTHAMERICA-NORTHEAST2"
  repository_id = "my-docker-repo"
  format        = "DOCKER"
}
