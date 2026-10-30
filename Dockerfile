FROM maven:3.9-eclipse-temurin-25 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests
RUN ls -la target
RUN find target -maxdepth 1 -name "*.jar" ! -name "*-plain.jar" ! -name "*.original" -exec cp {} /app/app.jar \;

FROM eclipse-temurin:25-jre
WORKDIR /app
COPY --from=build /app/app.jar /app/app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-Xmx300m", "-jar", "/app/app.jar"]
