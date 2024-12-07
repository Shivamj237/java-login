FROM eclipse-temurin:17-jdk-alpine AS builder

# Set work directory inside the container
WORKDIR /app

# Copy Maven configuration files
COPY pom.xml .
COPY src ./src

RUN apk add --no-cache maven && \
    mvn dependency:go-offline -B
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
EXPOSE 8080
# Default command to run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
