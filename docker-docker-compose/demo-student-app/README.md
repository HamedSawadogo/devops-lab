# Demo Student App — Full DevOps Pipeline

A student management CRUD application built with Spring Boot and PostgreSQL, deployed through a GitLab CI/CD pipeline and orchestrated on Kubernetes. This project covers the full DevOps lifecycle, from local development to production deployment.

## Functional Overview

Web interface to:
- List all students with a total count
- Create / edit / delete a student
- Server-side validation (unique email, age range, required fields)

## Tech Stack

| Layer | Technology |
|-------|------------|
| Backend | Spring Boot 3, Spring Data JPA, Thymeleaf |
| Database | PostgreSQL 16 |
| Build | Maven (multi-stage Docker build) |
| Containerization | Docker, Docker Compose |
| CI/CD | GitLab CI/CD |
| Orchestration | Kubernetes, Helm |

## Architecture

```
┌─────────────────────────────────────┐
│               User                  │
└──────────────┬──────────────────────┘
               │ HTTP
        ┌──────▼──────┐
        │   Ingress    │  (Nginx Ingress Controller)
        │  /api  /bd   │
        └──────┬───────┘
               │
      ┌────────▼─────────┐
      │  student-app     │  Spring Boot (3 replicas)
      │  port 9000       │
      └────────┬─────────┘
               │ JDBC
      ┌────────▼─────────┐
      │  PostgreSQL 16   │  with PersistentVolume
      └──────────────────┘
```

## GitLab CI/CD Pipeline

```
build ──► test ──► package ──► deploy-dev
```

| Stage | Action |
|-------|--------|
| `build` | Maven compilation, JAR generation |
| `test` | Unit test execution |
| `package` | Docker image build, push to Docker Hub (`sawadogoxxx/student-app:v1`) |
| `deploy-dev` | *(prepared)* SSH deployment to EC2 instance |

## Running Locally (Development)

```bash
# Start the app + database
docker compose up -d

# App available at http://localhost:9000
# PostgreSQL exposed on port 5460
```

## Production Deployment — Docker Compose

```bash
cd prod/

# Create the .env.prod file with sensitive variables
cp .env.prod.example .env.prod   # adjust to your environment

docker compose -f docker-compose.yaml up -d
```

The production image (`sawadogoxxx/student-app:v1.0`) is pulled from Docker Hub. Database credentials are injected via environment variables — no hardcoded secrets.

## Kubernetes Deployment

Manifests are located in the `prod/` folder:

```
prod/
├── student-app-deployment.yml      # 3 replicas, CPU/memory limits
├── student-app-service.yml         # ClusterIP
├── student-app-db-deployment.yaml  # PostgreSQL
├── student-app-db-service.yaml
├── student-app-ingress.yaml        # Nginx Ingress (routes /api and /bd)
├── student-app-secret.yaml         # Encrypted credentials
├── student-app-configs.yaml        # ConfigMap
├── student-app-volume.yml          # PersistentVolumeClaim
└── stuent-app-deployment/          # Equivalent Helm Chart
```

```bash
# Apply all manifests
kubectl apply -f prod/

# Or deploy via Helm
helm install student-app prod/stuent-app-deployment/
```

## DevOps Highlights

- **Multi-stage Dockerfile** — separate builder image from runtime image (JRE-only), non-root `spring` user
- **Healthcheck** — PostgreSQL waits to be ready before the app starts (`pg_isready`)
- **Kubernetes Secrets** — no plaintext credentials in manifests
- **Resource limits** — CPU and memory bounded on pods (`128Mi` / `500m`)
- **Scalability** — 3 replicas in production with preconfigured HPA (Helm)
- **Environment variables** — externalized configuration (12-factor app)

## Screenshots

| Dashboard | Form |
|-----------|------|
| ![dashboard](medias/Capture%20d'écran%20du%202026-06-15%2019-39-15.png) | ![form](medias/Capture%20d'écran%20du%202026-06-15%2019-40-44.png) |
