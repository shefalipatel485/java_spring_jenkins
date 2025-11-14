# Step 1: Use Maven image with Java 21 to build the project
FROM maven:3.9.6-eclipse-temurin-21 AS build

WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build the project (creates JAR in target/)
RUN mvn clean package -DskipTests


# Step 2: Use lightweight JRE 21 to run the app
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy the built JAR from previous stage
COPY --from=build /app/target/java_spring_jenkins-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080


# Run the Java app
ENTRYPOINT ["java", "-jar", "app.jar"]