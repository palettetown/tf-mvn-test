FROM openjdk:8-jre-alpine
COPY /home/runner/work/tf-mvn-test/tf-mvn-test/target/ app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
