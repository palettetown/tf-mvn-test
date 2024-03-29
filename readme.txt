set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_201
mvn dependency:copy-dependencies


~~~~~~~~~~~~******************~~~~~~~~~~~~~~~~~~~~~~~~~~******************~~~~~~~~~~~~~~
~~~~~~~~~~~~******************~~~~~~~~~~~~~~ LOCALLY BUILD & RUN IMAGE ~~~~~~~~~~~~******************~~~~~~~~~~~~~~
~~~~~~~~~~~~******************~~~~~~~~~~~~~~~~~~~~~~~~~~******************~~~~~~~~~~~~~~

C:\MyPrograms\CloudRunBatch>mvn compile

C:\MyPrograms\CloudRunBatch>mvn package

C:\MyPrograms\CloudRunBatch>java -jar target/gs-maven-0.1.0.jar
Welcome to our application


-----------BUILD DOCKER IMAGE -------------------

After that, let’s build our Docker image:
C:\MyPrograms\CloudRunBatch>docker image build -t docker-java-jar:latest .

Here, we use the -t flag to specify a name and tag in <name>:<tag> format. In this case, docker-java-jar is our image name, and the tag is latest. The “.” signifies the path where our Dockerfile resides. In this example, it’s simply the current directory.
Note: We can build different Docker images with the same name and different tags.
Finally, let’s run our Docker image from the command line:

C:\MyPrograms\CloudRunBatch>docker run docker-java-jar:latest
Welcome to our application

C:\MyPrograms\CloudRunBatch>







~~~~~~~~~~~~******************~~~~~~~~~~~~~~~~~~~~~~~~~~******************~~~~~~~~~~~~~~
~~~~~~~~~~~~******************~~~~~~~~~~~~~~ GCP BUILD & RUN IMAGE ~~~~~~~~~~~~******************~~~~~~~~~~~~~~
~~~~~~~~~~~~******************~~~~~~~~~~~~~~~~~~~~~~~~~~******************~~~~~~~~~~~~~~
https://cloud.google.com/build/docs/build-push-docker-image
Summary:
1. Create Docker File for JAR file (.sh file is ok too)
2. Create Docker repository in ARTIFACT REGISTRY
3. Build Image using CLOUD BUILD via YAML:
	In the same directory as Docker File:
		- Create YAML file that contains docker command to build image in ARTIFACT REGISTRY
		- This will use Docker file, build and push image to repo in ARTIFACT REGISTRY
		
----------2) CREATE DOCKER REPO in ARTIFACT REGISTRY-------

oahcsyue@cloudshell:~/batch/target (vaulted-hawk-406722)$ gcloud artifacts repositories create quickstart-docker-repo --repository-format=docker \
    --location=us-west2 --description="Docker repository"
	
Create request issued for: [quickstart-docker-repo]
Waiting for operation [projects/vaulted-hawk-406722/locations/us-west2/operations/007cf119-3850-48d5-9cba-cada035cb6f3] to complete...done.                                                                                                                                                              
Created repository [quickstart-docker-repo].
noahcsyue@cloudshell:~/batch/target (vaulted-hawk-406722)$ gcloud artifacts repositories list
Listing items under project vaulted-hawk-406722, across all locations.

ARTIFACT_REGISTRY

REPOSITORY: codelabrepo
FORMAT: DOCKER
MODE: STANDARD_REPOSITORY
DESCRIPTION: 
LOCATION: us-central1
LABELS: 
ENCRYPTION: Google-managed key
CREATE_TIME: 2024-01-18T17:51:45
UPDATE_TIME: 2024-01-22T21:47:11
SIZE (MB): 109.382

REPOSITORY: quickstart-docker-repo
FORMAT: DOCKER
MODE: STANDARD_REPOSITORY
DESCRIPTION: Docker repository
LOCATION: us-west2
LABELS: 
ENCRYPTION: Google-managed key
CREATE_TIME: 2024-02-25T15:43:26
UPDATE_TIME: 2024-02-25T15:43:26
SIZE (MB): 0
noahcsyue@cloudshell:~/batch/target (vaulted-hawk-406722)$ 


----------3) Build an image using a build config file-------

noahcsyue@cloudshell:~/batch (vaulted-hawk-406722)$ vi cloudbuild.yaml

~~~~~~~~~edit~~~~~~~~~~
steps:
- name: 'gcr.io/cloud-builders/docker'
  script: |
    docker build -t us-west2-docker.pkg.dev/$PROJECT_ID/quickstart-docker-repo/quickstart-image:tag1 .
  automapSubstitutions: true
images:
- 'us-west2-docker.pkg.dev/$PROJECT_ID/quickstart-docker-repo/quickstart-image:tag1'
~~~~~~~~~~~~~~~~~~~

noahcsyue@cloudshell:~/batch (vaulted-hawk-406722)$ gcloud builds submit --region=us-west2 --config cloudbuild.yaml

Creating temporary tarball archive of 3 file(s) totalling 2.7 KiB before compression.
Uploading tarball of [.] to [gs://vaulted-hawk-406722_cloudbuild/source/1708876035.46538-4ca52612d84d4b018da84dc4b63d4a27.tgz]
Created [https://cloudbuild.googleapis.com/v1/projects/vaulted-hawk-406722/locations/us-west2/builds/2197112e-04c2-4406-b867-5fa6803d7cba].
Logs are available at [ https://console.cloud.google.com/cloud-build/builds;region=us-west2/2197112e-04c2-4406-b867-5fa6803d7cba?project=267413452808 ].
------------------------------------------------------------------------------------------------------------------------------------------ REMOTE BUILD OUTPUT -------------------------------------------------------------------------------------------------------------------------------------------
starting build "2197112e-04c2-4406-b867-5fa6803d7cba"

FETCHSOURCE
Fetching storage object: gs://vaulted-hawk-406722_cloudbuild/source/1708876035.46538-4ca52612d84d4b018da84dc4b63d4a27.tgz#1708876037251700
Copying gs://vaulted-hawk-406722_cloudbuild/source/1708876035.46538-4ca52612d84d4b018da84dc4b63d4a27.tgz#1708876037251700...
/ [1 files][  2.1 KiB/  2.1 KiB]                                                
Operation completed over 1 objects/2.1 KiB.
SETUPBUILD
BUILD
Already have image (with digest): gcr.io/cloud-builders/docker
Sending build context to Docker daemon  6.656kB
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
 f7a292bbb70c
Step 2/3 : COPY target/gs-maven-0.1.0.jar app.jar
 1e1ea49d990a
Step 3/3 : ENTRYPOINT ["java","-jar","/app.jar"]
 Running in 531aa877df05
Removing intermediate container 531aa877df05
 3318e61a325a
Successfully built 3318e61a325a
Successfully tagged us-west2-docker.pkg.dev/vaulted-hawk-406722/quickstart-docker-repo/quickstart-image:tag1
PUSH
Pushing us-west2-docker.pkg.dev/vaulted-hawk-406722/quickstart-docker-repo/quickstart-image:tag1
The push refers to repository [us-west2-docker.pkg.dev/vaulted-hawk-406722/quickstart-docker-repo/quickstart-image]
0e3ce7209690: Preparing
edd61588d126: Preparing
9b9b7f3d56a0: Preparing
f1b5933fe4b5: Preparing
0e3ce7209690: Pushed
9b9b7f3d56a0: Pushed
f1b5933fe4b5: Pushed
edd61588d126: Pushed
tag1: digest: sha256:95202b8eebfbbf9cacdfc3d4b8551ff7f66f68c002260b265c9a1e57a542a0d3 size: 1155
DONE
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ID: 2197112e-04c2-4406-b867-5fa6803d7cba
CREATE_TIME: 2024-02-25T15:47:17+00:00
DURATION: 23S
SOURCE: gs://vaulted-hawk-406722_cloudbuild/source/1708876035.46538-4ca52612d84d4b018da84dc4b63d4a27.tgz
IMAGES: us-west2-docker.pkg.dev/vaulted-hawk-406722/quickstart-docker-repo/quickstart-image:tag1
STATUS: SUCCESS
noahcsyue@cloudshell:~/batch (vaulted-hawk-406722)$ 


~~~~~~~~~~~~******************~~~~~~~~~~~~~~~~~~~~~~~~~~******************~~~~~~~~~~~~~~
~~~~~~~~~~~~******************~~~~~~~~~~~~~~ GCP CLOUD RUN Create Job ~~~~~~~~~~~~******************~~~~~~~~~~~~~~
~~~~~~~~~~~~******************~~~~~~~~~~~~~~~~~~~~~~~~~~******************~~~~~~~~~~~~~~
https://cloud.google.com/run/docs/create-jobs
https://cloud.google.com/run/docs/configuring/max-retries#terraform

Summary
1. Create CLOUD RUN JOB using an existing image in ARTIFACT REGISTRY via Terraform


/Artifact Registry
Pull by tag 					<--- mutable, tag can point to a new image
$
docker pull \
    us-west2-docker.pkg.dev/vaulted-hawk-406722/quickstart-docker-repo/quickstart-image:tag1
Pull by digest					<--- immutable
$
docker pull \
    us-west2-docker.pkg.dev/vaulted-hawk-406722/quickstart-docker-repo/quickstart-image@sha256:95202b8eebfbbf9cacdfc3d4b8551ff7f66f68c002260b265c9a1e57a542a0d3	

	
/Cloud Shell
noahcsyue@cloudshell:~/batch (vaulted-hawk-406722)$ cat main.tf
resource "google_cloud_run_v2_job" "default" {
  provider     = google-beta
  name         = "cloud-run-job"
  location     = "us-central1"
  launch_stage = "BETA"

  template {
    template {
      containers {
        image = "us-west2-docker.pkg.dev/vaulted-hawk-406722/quickstart-docker-repo/quickstart-image:tag1"
      }
    }
  }
}

terraform init
terraform plan
terraform apply



