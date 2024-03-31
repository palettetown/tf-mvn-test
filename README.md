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

Note: can't use trigger and cloud build to create image out of the jar in GitHub. Since GitHub doesn't build the jar under /target in the repository (it goes to a different location inaccessible from outside).


   starting build "76bd022f-ad9b-4a0c-a993-446ca6fb7e1b"
   
   FETCHSOURCE
   hint: Using 'master' as the name for the initial branch. This default branch name
   hint: is subject to change. To configure the initial branch name to use in all
   hint: of your new repositories, which will suppress this warning, call:
   hint: 
   hint: 	git config --global init.defaultBranch <name>
   hint: 
   hint: Names commonly chosen instead of 'master' are 'main', 'trunk' and
   hint: 'development'. The just-created branch can be renamed via this command:
   hint: 
   hint: 	git branch -m <name>
   Initialized empty Git repository in /workspace/.git/
   From https://github.com/palettetown/tf-mvn-test
    * branch            7962eae6034c43cb1d9ec74d8b196cbd9d4cab6d -> FETCH_HEAD
   HEAD is now at 7962eae Update main.tf
   SETUPBUILD
   BUILD
   Already have image (with digest): gcr.io/cloud-builders/docker
   Sending build context to Docker daemon  142.3kB
   
   Step 1/3 : FROM openjdk:8-jre-alpine
   8-jre-alpine: Pulling from library/openjdk
   e7c96db7181b: Already exists
   f910a506b6cb: Already exists
   b6abafe80f63: Pulling fs layer
   b6abafe80f63: Verifying Checksum
   b6abafe80f63: Download complete
   b6abafe80f63: Pull complete
   Digest: sha256:f362b165b870ef129cbe730f29065ff37399c0aa8bcab3e44b51c302938c9193
   Status: Downloaded newer image for openjdk:8-jre-alpine
    ---> f7a292bbb70c
   Step 2/3 : COPY target/gs-maven-0.1.0.jar app.jar
   COPY failed: file not found in build context or excluded by .dockerignore: stat **target/gs-maven-0.1.0.jar**: file does not exist
   ERROR
   ERROR: build step 0 "gcr.io/cloud-builders/docker" failed: step exited with non-zero status: 1
