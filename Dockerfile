FROM maven:3.9.2-eclipse-temurin-11
WORKDIR /usr/src/app
COPY pom.xml /usr/src/app
COPY ./src/test/java /usr/src/app/src/test/java
#CMD mvn test