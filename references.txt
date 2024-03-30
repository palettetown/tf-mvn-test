# tf-mvn-test
test java before deploy
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_201
mvn dependency:copy-dependencies
https://www.youtube.com/watch?v=3tC42nIui6A&list=PL9ok7C7Yn9A-6uidd3RXZPf5EfhxkPXa_&index=3

https://mkyong.com/maven/how-to-run-unit-test-with-maven/


https://medium.com/@sbkapelner/building-and-pushing-to-artifact-registry-with-github-actions-7027b3e443c1
name: Build and Push to Artifact Registry

on:
  push:
    branches: ["main"]
  pull_request:
    branches: ["main"]

env:
  PROJECT_ID: fake-app-323017
  REGION: northamerica-northeast1
  GAR_LOCATION: northamerica-northeast1-docker.pkg.dev/fake-app-323017/repo-1/

job:
  build-push-artifact:
    runs-on: ubuntu-latest
    steps:
      - name: "Checkout"
        uses: "actions/checkout@v3"

      - id: "auth"
          uses: "google-github-actions/auth@v1"
          with:
            credentials_json: "${{ secrets.SERVICE_ACCOUNT_KEY }}"

      - name: "Set up Cloud SDK"
        uses: "google-github-actions/setup-gcloud@v1"

      - name: "Use gcloud CLI"
        run: "gcloud info"

      - name: "Docker auth"
        run: |-
          gcloud auth configure-docker ${{ env.REGION }}-docker.pkg.dev --quiet

      - name: Build image
        run: docker build . --file DOCKERFILE_LOCATION --tag ${{ env.GAR_LOCATION }}
        working-directory: WORKING_DIRECTORY

      - name: Push image
        run: docker push ${{ env.GAR_LOCATION }}
