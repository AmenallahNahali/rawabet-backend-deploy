# =========================
# Stage 1 : Build Maven + Java 17
# =========================
FROM maven:3.9.9-eclipse-temurin-17 AS build

WORKDIR /app

COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .
RUN chmod +x mvnw

RUN ./mvnw dependency:go-offline -B

COPY src ./src

RUN ./mvnw clean package -DskipTests


# =========================
# Stage 2 : Runtime Java 17
# =========================
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

RUN mkdir -p /app/uploads

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8081

ENTRYPOINT ["java", "-jar", "app.jar"]