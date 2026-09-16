# Documentación de Implementación - MiPortafolio

## Fecha: 13 de septiembre de 2026

## Resumen Ejecutivo
Se configuró el entorno de desarrollo local para el proyecto MiPortafolio (Java/JSP con Maven y Tomcat) y se desplegó exitosamente en el servidor local.

---

## Estado Actual del Proyecto

### ✅ Estado: ACTIVO Y EJECUTÁNDOSE
- **URL de acceso**: http://localhost:8080/MiPortafolio/
- **Servidor**: Tomcat 11.0.25 ejecutándose en puerto 8080
- **Estado del WAR**: Desplegado en `apache-tomcat-11.0.25/webapps/MiPortafolio.war`

---

## Cambios Realizados

### 1. Corrección de Errores de Código

#### 1.1 LoginServlet.java
- **Archivo**: `src/main/java/com/miportafolio/controller/LoginServlet.java`
- **Cambio**: Corregido error tipográfico en línea 1
  - Antes: `ñpackage com.miportafolio.controller;`
  - Después: `package com.miportafolio.controller;`

#### 1.2 SupabaseConfig.java
- **Archivo**: `src/main/java/com/miportafolio/config/SupabaseConfig.java`
- **Cambio**: Eliminada dependencia de cliente Supabase (no disponible en Maven Central)
  - Eliminadas clases: `SupabaseClient`, `SupabaseHttpClient`
  - Mantenidos métodos: `getSupabaseUrl()`, `getSupabaseKey()`
  - **Nota**: El proyecto ahora usa directamente PostgreSQL con JDBC

#### 1.3 SubirArchivoServlet.java
- **Archivo**: `src/main/java/com/miportafolio/controller/SubirArchivoServlet.java`
- **Cambio**: Reemplazada librería commons-fileupload con API nativa de Jakarta
  - Eliminadas importaciones de commons-fileupload2
  - Implementado uso de `@MultipartConfig` y `Part` API
  - Simplificado código de subida de archivos usando `Files.copy()`

### 2. Actualización de Dependencias (pom.xml)

#### 2.1 Eliminadas
- `io.supabase:supabase-java:2.3.0` - No disponible en Maven Central
- `commons-fileupload:commons-fileupload:1.5` - Reemplazado por API nativa

#### 2.2 Mantenidas
- `jakarta.servlet-api:6.0.0`
- `jakarta.servlet.jsp-api:3.1.0`
- `jakarta.servlet.jsp.jstl:3.0.0`
- `postgresql:42.7.2` - Para conexión a Supabase (PostgreSQL)
- `HikariCP:5.1.0` - Pool de conexiones
- `gson:2.10.1` - Procesamiento JSON
- `jbcrypt:0.4` - Hashing de contraseñas
- `commons-io:2.15.1` - Utilidades de archivos
- `slf4j-api:2.0.9` y `slf4j-simple:2.0.9` - Logging

---

## Instalaciones Realizadas

### 3. Java 25 (Eclipse Temurin)
- **Versión**: 25.0.2
- **Ubicación**: `C:\Users\ACER\.jdk\jdk-25.0.2`
- **Método de instalación**: winget
- **Paquete**: JDK 25 instalado para la actualización del runtime

### 4. Maven 3.9.16
- **Versión**: 3.9.16
- **Ubicación**: `C:\Users\ACER\Documents\MiPortafolio\apache-maven-3.9.16`
- **Método de instalación**: Descarga manual desde Apache Maven
- **URL de descarga**: https://dlcdn.apache.org/maven/maven-3/3.9.16/binaries/apache-maven-3.9.16-bin.zip

### 5. Tomcat 11.0.25
- **Versión**: 11.0.25
- **Ubicación**: `C:\Users\ACER\Documents\apache-tomcat-11.0.25`
- **Método de instalación**: Descarga manual desde Apache Tomcat
- **URL de descarga**: https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.25/bin/apache-tomcat-11.0.25-windows-x64.zip
- **Puerto**: 8080

---

## Proceso de Compilación y Despliegue

### 6. Compilación del Proyecto
```bash
mvn clean package
```
- **Resultado**: BUILD SUCCESS
- **Archivo generado**: `target/MiPortafolio.war`
- **Tiempo de compilación**: ~26 segundos

### 7. Despliegue en Tomcat
```bash
Copy-Item "target\MiPortafolio.war" "apache-tomcat-11.0.25\webapps\"
```
- **Resultado**: WAR copiado exitosamente
- **Ubicación**: `apache-tomcat-11.0.25\webapps\MiPortafolio.war`

### 8. Inicio de Tomcat
```bash
$env:CATALINA_HOME = "$PWD\apache-tomcat-11.0.25"
$env:JAVA_HOME = "C:\Users\ACER\.jdk\jdk-25.0.2"
& "$env:CATALINA_HOME\bin\startup.bat"
```
- **Resultado**: Tomcat iniciado correctamente
- **Variables de entorno configuradas**: CATALINA_HOME, JAVA_HOME

---

## Estructura de Archivos del Proyecto

### Archivos Principales
```
MiPortafolio/
├── pom.xml (actualizado)
├── Dockerfile (no utilizado)
├── README.md
├── .gitignore
├── src/
│   └── main/
│       ├── java/com/miportafolio/
│       │   ├── config/
│       │   │   ├── DatabaseConfig.java
│       │   │   └── SupabaseConfig.java (modificado)
│       │   ├── controller/
│       │   │   ├── LoginServlet.java (corregido)
│       │   │   ├── SubirArchivoServlet.java (modificado)
│       │   │   └── [otros servlets]
│       │   ├── dao/
│       │   ├── model/
│       │   └── service/
│       ├── resources/
│       │   └── application.properties
│       └── webapp/
│           ├── [páginas JSP]
│           └── WEB-INF/web.xml
├── target/
│   └── MiPortafolio.war (generado)
├── apache-maven-3.9.16/ (instalado)
├── apache-tomcat-11.0.25/ (instalado)
├── maven.zip (descargado)
└── tomcat.zip (descargado)
```

---

## Configuración Requerida

### Variables de Entorno (Sesión Actual)
- `JAVA_HOME`: `C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot`
- `CATALINA_HOME`: `C:\Users\ACER\Documents\apache-tomcat-11.0.25`
- `MAVEN_HOME`: `C:\Users\ACER\Documents\MiPortafolio\apache-maven-3.9.16`

### Configuración de Base de Datos
El proyecto requiere configuración de Supabase en `src/main/resources/application.properties`:
```properties
supabase.url=jdbc:postgresql://db.your-project.supabase.co:5432/postgres
supabase.username=postgres
supabase.password=your-password
supabase.database=postgres
```

---

## Comandos Útiles

### Para Compilar el Proyecto
```bash
cd c:\Users\ACER\Documents\MiPortafolio
$env:MAVEN_HOME = "$PWD\apache-maven-3.9.16"
$env:PATH = "$env:MAVEN_HOME\bin;$env:PATH"
mvn clean package
```

### Para Iniciar Tomcat
```bash
cd c:\Users\ACER\Documents\MiPortafolio
$env:CATALINA_HOME = "C:\Users\ACER\Documents\apache-tomcat-11.0.25"
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot"
& "$env:CATALINA_HOME\bin\startup.bat"
```

### Para Detener Tomcat
```bash
cd c:\Users\ACER\Documents\MiPortafolio
$env:CATALINA_HOME = "C:\Users\ACER\Documents\apache-tomcat-11.0.25"
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-17.0.20.101-hotspot"
& "$env:CATALINA_HOME\bin\shutdown.bat"
```

### Para Re-desplegar Cambios
```bash
# 1. Compilar
mvn clean package
# 2. Copiar WAR
Copy-Item "target\MiPortafolio.war" "C:\Users\ACER\Documents\apache-tomcat-11.0.25\webapps\" -Force
# 3. Tomcat detectará automáticamente el cambio y recargará
```

---

## Problemas Resueltos

### 1. Error de Compilación: Dependencia Supabase
- **Problema**: `io.supabase:supabase-java:2.3.0` no existe en Maven Central
- **Solución**: Eliminada dependencia, uso directo de PostgreSQL con JDBC

### 2. Error de Compilación: Commons FileUpload
- **Problema**: Versiones de commons-fileupload no compatibles con Jakarta EE 10
- **Solución**: Reemplazado con API nativa `@MultipartConfig` de Jakarta

### 3. Error: Docker no disponible
- **Problema**: Docker Desktop no iniciaba correctamente
- **Solución**: Cambio de estrategia a despliegue con Tomcat local

### 4. Error: CATALINA_HOME no definido
- **Problema**: Tomcat requería variable de entorno CATALINA_HOME
- **Solución**: Configuración de variables en sesión de PowerShell

---

## Próximos Pasos Recomendados

### 1. Configurar Base de Datos
- Crear proyecto en Supabase
- Configurar credenciales en `application.properties`
- Ejecutar script SQL para crear tablas (usuarios, archivos)

### 2. Probar Funcionalidades
- Registro de usuarios
- Login/Logout
- Subida de archivos
- Descarga de archivos
- Gestión de archivos

### 3. Configuración Permanente (Opcional)
- Agregar JAVA_HOME, CATALINA_HOME, MAVEN_HOME a variables de entorno del sistema
- Configurar Tomcat como servicio de Windows

---

## Notas Importantes

- **Tomcat está ejecutándose en segundo plano** - Para detenerlo, usar `shutdown.bat`
- **El WAR se despliega automáticamente** - Tomcat detecta cambios en webapps
- **Maven está instalado localmente** - No en PATH del sistema, requiere configuración por sesión
- **Java 25 está instalado localmente** - Disponible para el proyecto actualizado
- **El proyecto usa PostgreSQL directamente** - No requiere cliente Supabase específico

---

## Contacto y Soporte

Para problemas o preguntas, revisar:
- Logs de Tomcat: `C:\Users\ACER\Documents\apache-tomcat-11.0.25/logs/catalina.out`
- Logs de aplicación: `C:\Users\ACER\Documents\apache-tomcat-11.0.25/logs/localhost.YYYY-MM-DD.log`
- Documentación del proyecto: `README.md`

---

**Última actualización**: 13 de septiembre de 2026
**Estado del proyecto**: ✅ Desplegado y ejecutándose correctamente
