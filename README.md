# MiPortafolio

Portafolio personal desarrollado con Java/JSP, Maven y Supabase.

## Características

- Autenticación de usuarios (Login, Registro, Logout)
- Gestión de archivos/proyectos
- Subida, descarga y eliminación de archivos
- Dashboard personalizado
- Integración con Supabase para base de datos
- Soporte para imágenes, PDFs y documentos
- Diseño responsivo con CSS moderno

## Tecnologías

- **Java 25**
- **Jakarta EE 10** (Servlet API 6.0, JSP 3.1)
- **Maven** para gestión de dependencias
- **Supabase** como base de datos PostgreSQL
- **HikariCP** para pool de conexiones
- **BCrypt** para hashing de contraseñas
- **Apache Commons FileUpload** para subida de archivos
- **Tomcat 10** como servidor de aplicaciones
- **Docker** para contenedorización

## Estructura del Proyecto

```
MiPortafolio/
│
├── pom.xml
├── Dockerfile
├── README.md
└── .gitignore
│
└── src/
    └── main/
        │
        ├── java/
        │   └── com/
        │       └── miportafolio/
        │           │
        │           ├── config/
        │           │   ├── DatabaseConfig.java
        │           │   └── SupabaseConfig.java
        │           │
        │           ├── controller/
        │           │   ├── ArchivoServlet.java
        │           │   ├── ArchivoVisualizarServlet.java
        │           │   ├── DescargarArchivoServlet.java
        │           │   ├── EliminarArchivoServlet.java
        │           │   ├── LoginServlet.java
        │           │   ├── LogoutServlet.java
        │           │   ├── RegistroServlet.java
        │           │   ├── SubirArchivoServlet.java
        │           │   └── VisitarServlet.java
        │           │
        │           ├── dao/
        │           │   ├── ArchivoDAO.java
        │           │   └── UsuarioDAO.java
        │           │
        │           ├── model/
        │           │   ├── Archivo.java
        │           │   └── Usuario.java
        │           │
        │           └── service/
        │               ├── AuthService.java
        │               └── StorageService.java
        │
        ├── resources/
        │   └── application.properties
        │
        └── webapp/
            │
            ├── index.jsp
            ├── login.jsp
            ├── registro.jsp
            ├── dashboard.jsp
            │
            ├── css/
            │   └── style.css
            │
            ├── js/
            │
            ├── semanas/
            │
            ├── unidades/
            │
            ├── videos/
            │
            └── WEB-INF/
                └── web.xml
```

## Configuración

### 1. Configurar Supabase

Crea un archivo `src/main/resources/application.properties` con tus credenciales de Supabase:

```properties
# Supabase Configuration
supabase.url=jdbc:postgresql://db.your-project.supabase.co:5432/postgres
supabase.username=postgres
supabase.password=your-password
supabase.database=postgres

# Application Configuration
app.name=MiPortafolio
app.version=1.0-SNAPSHOT

# File Upload Configuration
upload.directory=/uploads
upload.max.size=10485760
upload.allowed.types=image/jpeg,image/png,image/gif,application/pdf

# Session Configuration
session.timeout=1800

# Logging Configuration
logging.level.root=INFO
logging.level.com.miportafolio=DEBUG
```

### 2. Configurar Base de Datos

Ejecuta el siguiente script SQL en tu base de datos Supabase:

```sql
-- Tabla de usuarios
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    rol VARCHAR(50) DEFAULT 'usuario',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de archivos
CREATE TABLE archivos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    tipo VARCHAR(50),
    url VARCHAR(500),
    usuario_id INTEGER REFERENCES usuarios(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices
CREATE INDEX idx_archivos_usuario_id ON archivos(usuario_id);
CREATE INDEX idx_usuarios_email ON usuarios(email);
```

## Instalación

### Requisitos Previos

- Java 25 o superior
- Maven 3.6 o superior
- Docker (opcional, para contenedorización)

### Compilar el Proyecto

```bash
mvn clean package
```

### Ejecutar Localmente

1. Copia el archivo WAR generado a tu instalación de Tomcat:
   ```bash
   cp target/MiPortafolio.war $TOMCAT_HOME/webapps/
   ```

2. Inicia Tomcat:
   ```bash
   $TOMCAT_HOME/bin/startup.sh
   ```

3. Accede a la aplicación en `http://localhost:8080/MiPortafolio/`

### Ejecutar con Docker

1. Construye la imagen Docker:
   ```bash
   docker build -t miportafolio .
   ```

2. Ejecuta el contenedor:
   ```bash
   docker run -p 8080:8080 miportafolio
   ```

3. Accede a la aplicación en `http://localhost:8080/`

## Uso

### Registro de Usuario

1. Accede a `/registro.jsp`
2. Completa el formulario con tus datos
3. Selecciona el rol (usuario o administrador)
4. Haz click en "Registrarse"

### Iniciar Sesión

1. Accede a `/login.jsp`
2. Ingresa tu email y contraseña
3. Haz click en "Iniciar Sesión"

### Subir Archivos

1. Inicia sesión en el dashboard
2. Completa el formulario de subida de archivos
3. Selecciona el archivo de tu computadora
4. Haz click en "Subir Archivo"

### Gestionar Archivos

- **Descargar**: Haz click en el botón "Descargar" junto a cada archivo
- **Eliminar**: Haz click en el botón "Eliminar" para borrar un archivo

## Desarrollo

### Ejecutar en Modo Desarrollo

Para desarrollo, puedes usar un servidor Tomcat embebido o configurar tu IDE para ejecutar el proyecto directamente.

### Agregar Nuevas Funcionalidades

1. Crea nuevos Servlets en `src/main/java/com/miportafolio/controller/`
2. Agrega nuevas páginas JSP en `src/main/webapp/`
3. Actualiza el archivo `web.xml` si es necesario
4. Actualiza el `pom.xml` si necesitas nuevas dependencias

## Seguridad

- Las contraseñas se almacenan usando BCrypt
- Las sesiones tienen un tiempo de expiración de 30 minutos
- Los archivos se validan por tipo y tamaño
- Las rutas protegidas requieren autenticación

## Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT.

## Contacto

Para preguntas o soporte, contacta a tu-email@ejemplo.com
