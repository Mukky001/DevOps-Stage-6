# STAGE 1: Build the application using a valid Maven image
# UPDATED: Changed from the invalid 3.8.7 tag to a standard 3.9 tag
FROM maven:3.9-eclipse-temurin-17 as build
WORKDIR /app
# Copy the project configuration
COPY pom.xml .
# Copy source code
COPY src ./src
# Build the JAR file
RUN mvn clean package -DskipTests

# STAGE 2: Minimal Java Runtime Environment
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
# Copy the JAR from the build stage
# The wildcard *.jar ensures we catch the file regardless of the specific version name
COPY --from=build /app/target/*.jar app.jar
# Expose the port (8083)
EXPOSE 8083
# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
