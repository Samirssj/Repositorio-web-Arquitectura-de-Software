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
COPY --from=build /app/target/MiPortafolio.war /usr/local/tomcat/webapps/ROOT.war

RUN printf '#!/bin/sh\n\
PORT=${PORT:-8080}\n\
echo "Iniciando Tomcat en puerto ${PORT}"\n\
sed -i "s/port=\"8080\"/port=\"${PORT}\"/" /usr/local/tomcat/conf/server.xml\n\
exec catalina.sh run\n\
' > /usr/local/tomcat/start.sh \
&& chmod +x /usr/local/tomcat/start.sh

# Puerto utilizado por Tomcat
EXPOSE 8080

# Iniciar Tomcat
CMD ["/usr/local/tomcat/start.sh"]