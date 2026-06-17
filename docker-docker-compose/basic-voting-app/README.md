# Basic Voting App — Docker + Nginx

A simple voting web app, containerized and served by Nginx. This project demonstrates how to package a static frontend as a production-ready Docker image.

## Overview

Users vote for their favorite programming language (JavaScript, Python, Java). Votes are persisted client-side via `localStorage` and displayed in real time.

## Tech Stack

| Tool | Role |
|------|------|
| Docker | Application containerization |
| Nginx | Web server with custom configuration |
| HTML/CSS/JS | Vanilla frontend, no external dependencies |

## Architecture

```
browser
   └── Nginx (port 80)
          └── /usr/share/nginx/html/index.html
```

The Docker image bundles the static HTML file and a production-optimized Nginx configuration.

## Nginx Configuration Highlights

- **Gzip compression** — reduces transferred asset size
- **Aggressive caching** — `Cache-Control: immutable` headers on static assets (JS, CSS, images)
- **Security headers** — `X-Frame-Options`, `X-Content-Type-Options`, `X-XSS-Protection`, `Referrer-Policy`
- **SPA fallback** — `try_files` to support client-side routing

## Running the Project

```bash
# Build the image
docker build -t voting-app .

# Start the container
docker run -d -p 8080:80 voting-app
```

App available at [http://localhost:8080](http://localhost:8080).

## What This Project Demonstrates

- Building a lightweight Docker image from `nginx:latest`
- Customizing Nginx configuration for production (security + performance)
- Packaging and distributing a static frontend via Docker
