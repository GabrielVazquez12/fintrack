# FinTrack

Aplicación full-stack de finanzas personales — frontend en Flutter, backend
REST en Java Spring Boot, base de datos MySQL en Amazon RDS, contenerizada
con Docker y desplegada en AWS EC2.

Proyecto de portafolio construido para practicar y demostrar un stack
completo end-to-end: Flutter, Riverpod, Java, Spring Boot, JPA/Hibernate,
Spring Security + JWT, MySQL, Docker y AWS.

## Estado del proyecto

| Área | Estado |
|---|---|
| Frontend Flutter | ✅ Completo |
| Backend Spring Boot | ✅ Completo |
| Integración frontend ↔ backend | ✅ Probada en dispositivo real |
| Contenerización con Docker | ✅ Completa |
| Despliegue en AWS (EC2 + RDS) | ✅ Completo, probado en producción |

## Arquitectura

```
┌─────────────────┐         HTTPS/JSON         ┌──────────────────────┐
│  Flutter App     │ ─────────────────────────▶ │   AWS EC2            │
│  (Android/iOS)   │                              │   Spring Boot API    │
│  Riverpod state  │ ◀───────────────────────── │   (Docker container) │
└─────────────────┘         JWT auth            └───────────┬───────────┘
                                                              │ JDBC
                                                              ▼
                                                  ┌──────────────────────┐
                                                  │   AWS RDS              │
                                                  │   MySQL 8.4            │
                                                  └──────────────────────┘
```

## Estructura del repositorio

```
fintrack/
├── frontend/           Flutter app
├── backend/             Spring Boot API
│   ├── Dockerfile       Multi-stage build (Maven → JRE Alpine)
│   └── .dockerignore
├── docker-compose.yml   Backend + MariaDB para desarrollo local
└── .gitignore
```

## Frontend (`frontend/`)

**Stack:** Flutter, Riverpod (manejo de estado), `dio` (cliente HTTP),
`fl_chart` (gráficas), `google_fonts`.

**Dirección de diseño — "Ledger":** verde bosque (`#1B3A2F`), marfil
(`#F7F3EC`), dorado (`#C9A15A`) y terracota (`#B5533C`). Tipografía PT Serif
para montos, Inter para el resto.

**Pantallas:**
- Login / Registro, con validación contra el backend real
- Dashboard — balance total, gráfica de gastos por categoría, movimientos
  recientes
- Crear cuenta
- Lista completa de movimientos
- Agregar movimiento — ingreso o gasto, con selector de cuenta y categoría

### Cómo correrlo

```bash
cd frontend
flutter pub get
flutter run
```

`lib/services/api_service.dart` apunta por default al backend desplegado en
producción. Para desarrollo local, cambia `baseUrl` a la IP de tu máquina
en la misma red que el dispositivo de pruebas.

## Backend (`backend/`)

**Stack:** Java 21, Spring Boot, Spring Web, Spring Data JPA, Spring
Security, JWT (`jjwt`), MySQL Driver, Bean Validation, Maven.

**Arquitectura por capas:**
```
model/        Entidades JPA — User, Account, Category, Transaction
repository/   Interfaces JpaRepository con query derivation
service/      Lógica de negocio (registro, login, creación de recursos)
controller/   Endpoints REST
dto/          Request/response objects (Java records)
config/       Seguridad (JWT), seed de categorías
exception/    Manejo global de errores (@RestControllerAdvice)
```

**Seguridad:** autenticación JWT sin estado (stateless). Contraseñas
encriptadas con BCrypt — nunca se almacenan en texto plano. Todos los
endpoints bajo `/api/auth/**` son públicos; el resto requiere un token
válido en el header `Authorization: Bearer <token>`.

### Endpoints

| Método | Ruta                  | Descripción                        | Auth |
|--------|-----------------------|-------------------------------------|------|
| POST   | `/api/auth/register`  | Crea un usuario, regresa JWT        | No   |
| POST   | `/api/auth/login`     | Autentica, regresa JWT              | No   |
| GET    | `/api/accounts`       | Lista las cuentas del usuario       | Sí   |
| POST   | `/api/accounts`       | Crea una cuenta                     | Sí   |
| GET    | `/api/transactions`   | Lista los movimientos del usuario   | Sí   |
| POST   | `/api/transactions`   | Crea un movimiento                  | Sí   |

Al arrancar, un `CommandLineRunner` precarga automáticamente las 10
categorías por default (comida, transporte, salario, etc.), con códigos que
coinciden 1:1 con los IDs de categoría usados en el frontend.

### Cómo correrlo localmente

```bash
cd backend
./mvnw spring-boot:run
```

Requiere MySQL/MariaDB corriendo localmente con las credenciales
configuradas en `src/main/resources/application.yaml` (soporta variables de
entorno `SPRING_DATASOURCE_URL`, `SPRING_DATASOURCE_USERNAME`,
`SPRING_DATASOURCE_PASSWORD` para no hardcodear credenciales).

## Docker

El backend usa un **multi-stage build**: una etapa compila el proyecto con
Maven sobre una imagen JDK completa, y la etapa final copia solo el `.jar`
resultante a una imagen ligera `eclipse-temurin:21-jre-alpine` — esto reduce
significativamente el tamaño de la imagen final frente a incluir todo el
toolchain de build.

```bash
# Backend + base de datos MariaDB, para desarrollo local
docker compose up --build

# Solo el backend (por ejemplo, apuntando a una base de datos externa como RDS)
cd backend
docker build -t fintrack-backend .
docker run -d -p 8080:8080 \
  -e SPRING_DATASOURCE_URL="jdbc:mysql://<host>:3306/fintrack_db" \
  -e SPRING_DATASOURCE_USERNAME="<user>" \
  -e SPRING_DATASOURCE_PASSWORD="<password>" \
  fintrack-backend
```

## Despliegue en AWS

**Infraestructura:**
- **Amazon RDS (MySQL 8.4)** — base de datos administrada, sin acceso
  público; solo acepta conexiones desde el Security Group del backend.
- **Amazon EC2 (Ubuntu, t3.micro)** — corre el contenedor Docker del
  backend.
- **Security Groups** configurados con el principio de menor privilegio:
  - `fintrack-backend-sg`: SSH restringido a la IP del desarrollador, API
    (puerto 8080) abierta al público.
  - `fintrack-db-sg`: MySQL (puerto 3306) accesible únicamente desde
    `fintrack-backend-sg`, nunca desde internet.

**Flujo de despliegue:**
```bash
ssh -i fintrack-key.pem ubuntu@<ec2-public-ip>
git clone https://github.com/GabrielVazquez12/fintrack.git
cd fintrack/backend
docker build -t fintrack-backend .
docker run -d --name fintrack-backend -p 8080:8080 \
  -e SPRING_DATASOURCE_URL="jdbc:mysql://<rds-endpoint>:3306/fintrack_db" \
  -e SPRING_DATASOURCE_USERNAME="admin" \
  -e SPRING_DATASOURCE_PASSWORD="<password>" \
  fintrack-backend
```

## Autor

Carlos Gabriel Vázquez Vélez 