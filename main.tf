terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.21.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = "my-second-project-418213"
  region  = "northamerica-northeast2"
  #credentials = file("C:\\MyPrograms\\GCP\\my-second-project-418213-c4584d61b2a8.json")
}

# Task 2: Create Docker repository in GCP Artifact Registry
resource "google_artifact_registry_repository" "docker_repo" {
  provider      = google
  project       = "my-second-project-418213"
  location      = "us-central1"
  repository_id = "my-docker-repo"
  format        = "DOCKER"
}

# Task 3: Create Docker image and upload to the Docker repository
resource "google_cloudbuild_trigger" "build_trigger" {
  name        = "docker-image-build-trigger"
  description = "Trigger to build and push Docker image to Artifact Registry"
  trigger_template {
    repo_name   = google_artifact_registry_repository.docker_repo.name
    branch_name = "^main$"
  }
  filename = "cloudbuild.yaml"
}
