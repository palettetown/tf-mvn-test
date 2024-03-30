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



>>>>>>>>>>>>>>>>>>>>  TF  <<<<<<<<<<<<<<<<<<<<<<<<<<<<

----------------- Note: March 20, 2024 -------------------------------
---Github CICD Note---

Problem: Created terraform resource for trigger to build JAR with DOCKER File into an image after MVN install.
   Hoping Github Trigger to build image using the JAR file created in Github, then push to Artifact REGISTRY Docker Repo
> However, GCP trigger cannot find the Jar under /target in GITHUB
Reason: GITHUB does NOT create the file directly under /target in the repository, it created somewhere in GITHUB (hidden) as the following, which is not accessible from ANYWHERE!!!
	[INFO] Installing /home/runner/work/tf-mvn-test/tf-mvn-test/target/gs-maven-0.1.0.jar to /home/runner/.m2/repository/org/springframework/gs-maven/0.1.0/gs-maven-0.1.0.jar
	
Workround & Solution

{
Some posting online: https://stackoverflow.com/questions/75840164/permission-artifactregistry-repositories-uploadartifacts-denied-on-resource-usin/76078997#76078997?newreg=1fe0722246ba4a598f0cc744ca768a9c
Ok, I spent a lot of time on this now and there are two possible solutions:
Log into gcloud: gcloud auth login
Configure docker: gcloud auth configure-docker europe-west1-docker.pkg.dev (make sure to specify appropriate region)
The second one did it for me.
}

Here is what I did.

I tried these step WITHIN MVN BUILD block (job) in yaml and not part of the Terraform block (job), 
since it's only within the SAME BUILD block that it can still find the JAR and IMAGE in the "hidden" /target folder

Summary:
1. Build JAR with Maven -> created in /taget folder
2. Docker to create image from the above JAR in /target using Docker File
3. Push image created by Docker to Artifact Registry Docker Repo

    - name: Build JAR with Maven
      run: mvn -B package
    - name: Build Docker Image
      run: docker build -t us-central1-docker.pkg.dev/my-second-project-418213/my-docker-repo/quickstart-image:tag1 .

    # Configure Workload Identity Federation via a credentials file.
    - id: 'auth'
      name: 'Authenticate to Google Cloud'
      uses: 'google-github-actions/auth@v1'
      with:
        create_credentials_file: true
        workload_identity_provider: 'projects/198122355685/locations/global/workloadIdentityPools/githubactions/providers/github'
        service_account: 'ksyservacc@my-second-project-418213.iam.gserviceaccount.com'
        token_format: "access_token"
    
    - id: 'gcloud'
      name: 'Auth Docker & Push Image'
      run: |-             
        gcloud auth login --brief --cred-file="${{ steps.auth.outputs.credentials_file_path }}" --no-user-output-enabled
        gcloud auth configure-docker us-central1-docker.pkg.dev
        docker push us-central1-docker.pkg.dev/my-second-project-418213/my-docker-repo/quickstart-image:tag1
		
LOGS>>		
Build JAR with Maven:
	Run mvn -B package
	  mvn -B package
	  shell: /usr/bin/bash -e {0}
	  env:
		JAVA_HOME: /opt/hostedtoolcache/Java_Temurin-Hotspot_jdk/8.0.402-6/x64
		JAVA_HOME_8_X64: /opt/hostedtoolcache/Java_Temurin-Hotspot_jdk/8.0.402-6/x64
	[INFO] Scanning for projects...
	[INFO] 
	[INFO] --------------------< org.springframework:gs-maven >--------------------
	[INFO] Building gs-maven 0.1.0
	[INFO]   from pom.xml
	[INFO] --------------------------------[ jar ]---------------------------------
	[INFO] 
	[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ gs-maven ---
	Warning:  Using platform encoding (UTF-8 actually) to copy filtered resources, i.e. build is platform dependent!
	[INFO] skip non existing resourceDirectory /home/runner/work/tf-mvn-test/tf-mvn-test/src/main/resources
	[INFO] 
	[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ gs-maven ---
	[INFO] Changes detected - recompiling the module!
	Warning:  File encoding has not been set, using platform encoding UTF-8, i.e. build is platform dependent!
	[INFO] Compiling 3 source files to /home/runner/work/tf-mvn-test/tf-mvn-test/target/classes
	[INFO] 
	[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ gs-maven ---
	Warning:  Using platform encoding (UTF-8 actually) to copy filtered resources, i.e. build is platform dependent!
	[INFO] skip non existing resourceDirectory /home/runner/work/tf-mvn-test/tf-mvn-test/src/test/resources
	[INFO] 
	[INFO] --- maven-compiler-plugin:3.1:testCompile (default-testCompile) @ gs-maven ---
	[INFO] Changes detected - recompiling the module!
	Warning:  File encoding has not been set, using platform encoding UTF-8, i.e. build is platform dependent!
	[INFO] Compiling 1 source file to /home/runner/work/tf-mvn-test/tf-mvn-test/target/test-classes
	[INFO] 
	[INFO] --- maven-surefire-plugin:2.22.0:test (default-test) @ gs-maven ---
	[INFO] 
	[INFO] -------------------------------------------------------
	[INFO]  T E S T S
	[INFO] -------------------------------------------------------
	[INFO] Running TestMagicBuilder
	[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.006 s - in TestMagicBuilder
	[INFO] 
	[INFO] Results:
	[INFO] 
	[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
	[INFO] 
	[INFO] 
	[INFO] --- maven-jar-plugin:2.4:jar (default-jar) @ gs-maven ---
	[INFO] Building jar: /home/runner/work/tf-mvn-test/tf-mvn-test/target/gs-maven-0.1.0.jar
	[INFO] 
	[INFO] --- maven-shade-plugin:3.2.4:shade (default) @ gs-maven ---
	[INFO] Replacing original artifact with shaded artifact.
	[INFO] Replacing /home/runner/work/tf-mvn-test/tf-mvn-test/target/gs-maven-0.1.0.jar with /home/runner/work/tf-mvn-test/tf-mvn-test/target/gs-maven-0.1.0-shaded.jar
	[INFO] ------------------------------------------------------------------------
	[INFO] BUILD SUCCESS
	[INFO] ------------------------------------------------------------------------
	[INFO] Total time:  3.412 s
	[INFO] Finished at: 2024-03-30T18:48:20Z
	[INFO] ------------------------------------------------------------------------

Build Docker Image:
	#0 building with "default" instance using docker driver
	#1 [internal] load build definition from Dockerfile
	#1 transferring dockerfile: 140B done
	#1 DONE 0.0s
	#2 [internal] load .dockerignore
	#2 transferring context: 2B done
	#2 DONE 0.0s
	#3 [internal] load metadata for docker.io/library/openjdk:8-jre-alpine
	#3 ...
	#4 [auth] library/openjdk:pull token for registry-1.docker.io
	#4 DONE 0.0s
	#3 [internal] load metadata for docker.io/library/openjdk:8-jre-alpine
	#3 DONE 1.0s
	#5 [internal] load build context
	#5 transferring context: 3.32kB done
	#5 DONE 0.0s
	#6 [1/2] FROM docker.io/library/openjdk:8-jre-alpine@sha256:f362b165b870ef129cbe730f29065ff37399c0aa8bcab3e44b51c302938c9193
	#6 resolve docker.io/library/openjdk:8-jre-alpine@sha256:f362b165b870ef129cbe730f29065ff37399c0aa8bcab3e44b51c302938c9193 done
	#6 sha256:f362b165b870ef129cbe730f29065ff37399c0aa8bcab3e44b51c302938c9193 1.64kB / 1.64kB done
	#6 sha256:b2ad93b079b1495488cc01375de799c402d45086015a120c105ea00e1be0fd52 947B / 947B done
	#6 sha256:f7a292bbb70c4ce57f7704cc03eb09e299de9da19013b084f138154421918cb4 3.42kB / 3.42kB done
	#6 sha256:e7c96db7181be991f19a9fb6975cdbbd73c65f4a2681348e63a141a2192a5f10 0B / 2.76MB 0.1s
	#6 sha256:f910a506b6cb1dbec766725d70356f695ae2bf2bea6224dbe8c7c6ad4f3664a2 0B / 238B 0.1s
	#6 sha256:b6abafe80f63b02535fc111df2ed6b3c728469679ab654e03e482b6f347c9639 0B / 54.94MB 0.1s
	#6 sha256:e7c96db7181be991f19a9fb6975cdbbd73c65f4a2681348e63a141a2192a5f10 2.76MB / 2.76MB 0.2s done
	#6 sha256:f910a506b6cb1dbec766725d70356f695ae2bf2bea6224dbe8c7c6ad4f3664a2 238B / 238B 0.2s done
	#6 extracting sha256:e7c96db7181be991f19a9fb6975cdbbd73c65f4a2681348e63a141a2192a5f10 0.1s done
	#6 sha256:b6abafe80f63b02535fc111df2ed6b3c728469679ab654e03e482b6f347c9639 29.36MB / 54.94MB 0.4s
	#6 extracting sha256:f910a506b6cb1dbec766725d70356f695ae2bf2bea6224dbe8c7c6ad4f3664a2 done
	#6 sha256:b6abafe80f63b02535fc111df2ed6b3c728469679ab654e03e482b6f347c9639 54.94MB / 54.94MB 0.6s
	#6 sha256:b6abafe80f63b02535fc111df2ed6b3c728469679ab654e03e482b6f347c9639 54.94MB / 54.94MB 0.6s done
	#6 extracting sha256:b6abafe80f63b02535fc111df2ed6b3c728469679ab654e03e482b6f347c9639 0.1s
	#6 extracting sha256:b6abafe80f63b02535fc111df2ed6b3c728469679ab654e03e482b6f347c9639 0.6s done
	#6 DONE 1.4s
	#7 [2/2] COPY target/gs-maven-0.1.0.jar app.jar
	#7 DONE 0.0s
	#8 exporting to image
	#8 exporting layers
	#8 exporting layers 0.6s done
	#8 writing image sha256:8d201d6e346f36ec3ceccc96080e0192866e3f9ad2dbfb9170170cb53394378c done
	#8 naming to us-central1-docker.pkg.dev/my-second-project-418213/my-docker-repo/quickstart-image:tag1 done
	#8 DONE 0.6s

Authenticate to Google Cloud:
	Run google-github-actions/auth@v1
	  with:
		create_credentials_file: true
		workload_identity_provider: projects/198122355685/locations/global/workloadIdentityPools/githubactions/providers/github
		service_account: ksyservacc@my-second-project-418213.iam.gserviceaccount.com
		token_format: access_token
		export_environment_variables: true
		cleanup_credentials: true
		access_token_lifetime: 3600s
		access_token_scopes: https://www.googleapis.com/auth/cloud-platform
		retries: 3
		backoff: 250
		id_token_include_email: false
	  env:
		JAVA_HOME: /opt/hostedtoolcache/Java_Temurin-Hotspot_jdk/8.0.402-6/x64
		JAVA_HOME_8_X64: /opt/hostedtoolcache/Java_Temurin-Hotspot_jdk/8.0.402-6/x64
	  
Created credentials file at "/home/runner/work/tf-mvn-test/tf-mvn-test/gha-creds-910db60f450d15e4.json"


Auth Docker & Push:

	Run gcloud auth login --brief --cred-file="/home/runner/work/tf-mvn-test/tf-mvn-test/gha-creds-910db60f450d15e4.json" --no-user-output-enabled
	  gcloud auth login --brief --cred-file="/home/runner/work/tf-mvn-test/tf-mvn-test/gha-creds-910db60f450d15e4.json" --no-user-output-enabled
	  gcloud auth configure-docker us-central1-docker.pkg.dev
	  docker push us-central1-docker.pkg.dev/my-second-project-418213/my-docker-repo/quickstart-image:tag1
		  
	  shell: /usr/bin/bash -e {0}
	  env:
		JAVA_HOME: /opt/hostedtoolcache/Java_Temurin-Hotspot_jdk/8.0.402-6/x64
		JAVA_HOME_8_X64: /opt/hostedtoolcache/Java_Temurin-Hotspot_jdk/8.0.402-6/x64
		CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE: /home/runner/work/tf-mvn-test/tf-mvn-test/gha-creds-910db60f450d15e4.json
		GOOGLE_APPLICATION_CREDENTIALS: /home/runner/work/tf-mvn-test/tf-mvn-test/gha-creds-910db60f450d15e4.json
		GOOGLE_GHA_CREDS_PATH: /home/runner/work/tf-mvn-test/tf-mvn-test/gha-creds-910db60f450d15e4.json
		CLOUDSDK_CORE_PROJECT: my-second-project-418213
		CLOUDSDK_PROJECT: my-second-project-418213
		GCLOUD_PROJECT: my-second-project-418213
		GCP_PROJECT: my-second-project-418213
		GOOGLE_CLOUD_PROJECT: my-second-project-418213
	  
	You are already authenticated with 
	'ksyservacc@my-second-project-418213.iam.gserviceaccount.com'.
	Do you wish to proceed and overwrite existing credentials?
	Do you want to continue (Y/n)?  
	Adding credentials for: us-central1-docker.pkg.dev
	After update, the following will be written to your Docker config file located 
	at [/home/runner/.docker/config.json]:
	 {
	  "credHelpers": {
		"us-central1-docker.pkg.dev": "gcloud"
	  }
	}
	Do you want to continue (Y/n)?  
	Docker configuration file updated.
	The push refers to repository [us-central1-docker.pkg.dev/my-second-project-418213/my-docker-repo/quickstart-image]
	9b41d16926ce: Preparing
	edd61588d126: Preparing
	9b9b7f3d56a0: Preparing
	f1b5933fe4b5: Preparing
	edd61588d126: Layer already exists
	9b9b7f3d56a0: Layer already exists
	f1b5933fe4b5: Layer already exists
	9b41d16926ce: Pushed
	tag1: digest: sha256:1055be23a3f122fe0073173a6ddb15e689913cdb7f2202c63b1a7677ca0650f8 size: 1155
		