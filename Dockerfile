# ============================================================
# ETAPA 1: COMPILAR LA APLICACIÓN CON MAVEN
# ============================================================
FROM maven:3.9.9-eclipse-temurin-17 AS build

WORKDIR /app

# Copiar primero el pom.xml
COPY pom.xml .

# Copiar el código fuente
COPY src ./src

# Compilar el proyecto y generar el WAR
RUN mvn clean package -DskipTests


# ============================================================
# ETAPA 2: EJECUTAR LA APLICACIÓN CON TOMCAT
# ============================================================
FROM tomcat:10.1-jdk17

# Eliminar aplicaciones de ejemplo de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Crear directorio para archivos de la aplicación
RUN mkdir -p /usr/local/tomcat/webapps/uploads

# Copiar el WAR generado por Maven
COPY --from=build /app/target/MiPortafolio.war /usr/local/tomcat/webapps/MiPortafolio.war

# Puerto utilizado por Tomcat
EXPOSE 8080

# Iniciar Tomcat
CMD ["catalina.sh", "run"]