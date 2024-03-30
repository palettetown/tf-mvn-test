This program prints out a Welcome Message in the Log in Google Cloud Run Job.
It will use CICD Github Actions :
   Committing any changes (git push) will invoke the Github Action to push Docker image, and then it will be automatically picked up by Cloud Run.

Job: Build
1. Build JAR with Maven -> created in /taget folder in Github
2. Build Docker Image in Github
3. Authenticate to Google Cloud
4. Auth Docker & Push Image to Google Artifact Registry Docker Repo 
   
Job: Terraform
1. Create Docker repository in GCP Artifact Registry
2. Create Cloud Run Job with Docker Image
