# Build stage
FROM gradle:8.5-jdk17 AS build
WORKDIR /app
COPY . .
RUN gradle bootWar -x test -x integrationTest --no-daemon

# Run stage
FROM tomcat:10.1-jdk17
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/build/libs/app.war /usr/local/tomcat/webapps/todo-ui.war
ENV SPRING_PROFILES_ACTIVE=prod
ENV JAVA_OPTS="-Xmx512m -Xms256m"
EXPOSE 8080
CMD ["catalina.sh", "run"] 