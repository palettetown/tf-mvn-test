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
#resource "google_artifact_registry_repository" "docker_repo" {
#  provider      = google
#  project       = "my-second-project-418213"
#  location      = "us-central1"
#  repository_id = "my-docker-repo"
#  format        = "DOCKER"
#}

# Task 3: Create Docker image and upload to the Docker repository
#resource "google_cloudbuild_trigger" "build_trigger" {
#  name        = "docker-image-build-trigger"
#  description = "Trigger to build and push Docker image to Artifact Registry"
#  trigger_template {
#    repo_name   = google_artifact_registry_repository.docker_repo.name
#    branch_name = "main"
#  }
#  filename = "cloudbuild.yaml"
#}

#resource "google_project_service" "cloud_run_api" {
#  service = "run.googleapis.com"
#}

resource "google_cloud_run_v2_job" "default" {
  name     = "cloudrun-job"
  location = "us-central1"

  template {
    template {
      containers {
        image = "us-central1-docker.pkg.dev/my-second-project-418213/my-docker-repo/quickstart-image:tag1"
      }
    }
  }
#  depends_on = [ // Here
#    google_project_service.cloud_run_api
#  ]
#}
