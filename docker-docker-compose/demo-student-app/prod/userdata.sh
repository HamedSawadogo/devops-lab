#!/bin/bash
set -euxo pipefail
exec > /var/log/userdata.log 2>&1

# ── 1. System update ─────────────────────────────────────────────────────────
dnf update -y

# ── 2. Install Docker ─────────────────────────────────────────────────────────
dnf install -y docker
systemctl enable --now docker

# ── 3. Install Docker Compose v2 plugin ──────────────────────────────────────
COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest \
  | grep '"tag_name"' | cut -d '"' -f4)
mkdir -p /usr/local/lib/docker/cli-plugins
curl -SL "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-linux-x86_64" \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# ── 4. Write docker-compose.yaml ─────────────────────────────────────────────
mkdir -p /opt/student-app
cat > /opt/student-app/docker-compose.yaml << 'EOF'
version: '3.8'
services:
  app:
    image: sawadogoxxx/student-app:v1.0
    restart: always
    ports:
      - "80:9000"
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://studentdb.cjea4soayf0z.eu-west-3.rds.amazonaws.com:5432/postgres
      SPRING_DATASOURCE_USERNAME: student
      SPRING_DATASOURCE_PASSWORD: student123
EOF

# ── 5. Pull image & start container ──────────────────────────────────────────
cd /opt/student-app
docker compose pull
docker compose up -d

echo "✔ student-app started on port 80"
