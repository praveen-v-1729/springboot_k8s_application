FROM openjdk:8-jdk-alpine
ARG JAR_FILE
COPY ./target/*.jar /app.jar
CMD ["java", "-jar", "/app.jar"]





