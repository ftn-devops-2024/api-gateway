# Use a base image with Maven and JDK pre-installed
FROM maven:3.8.4-openjdk-8-slim AS build

# Set the working directory in the container
WORKDIR /app

# Copy the Maven project definition file
COPY API-gateway/pom.xml .

# Copy the source code
COPY API-gateway/src ./src

# Build the application
RUN mvn clean package -DskipTests

FROM curlimages/curl:8.2.1 AS download
ARG OTEL_AGENT_VERSION="1.33.2"
RUN curl --silent --fail -L "https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v${OTEL_AGENT_VERSION}/opentelemetry-javaagent.jar" \
    -o "$HOME/opentelemetry-javaagent.jar"

# Use a lightweight base image with JRE pre-installed
FROM openjdk:8-slim

# Set the working directory in the container
WORKDIR /app

# Copy the compiled JAR file from the previous stage
COPY --from=build /app/target/*.jar ./app.jar

COPY --from=download /home/curl_user/opentelemetry-javaagent.jar /opentelemetry-javaagent.jar

# Expose the port the application runs on
EXPOSE 8000

# Command to run the application
ENTRYPOINT ["java", "-javaagent:/opentelemetry-javaagent.jar", "-jar", "app.jar"]
