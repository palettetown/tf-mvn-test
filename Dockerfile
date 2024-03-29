FROM openjdk:8-jre-alpine
COPY /home/runner/work/tf-mvn-test/tf-mvn-test/target/gs-maven-0.1.0.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
