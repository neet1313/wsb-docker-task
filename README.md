# Docker Setup for React App (Production)

This documentation explains how to build and run your **React application** with Docker using **multi-stage builds** and **Nginx** for production.

---

## Table of Contents

1. [Overview](#overview)
2. [Directory Structure](#directory-structure)
3. [Dockerfile Explained](#dockerfile-explained)
4. [.dockerignore](#dockerignore)
5. [Building the Docker Image](#building-the-docker-image)
6. [Running the Container](#running-the-container)
7. [Updating the Image](#updating-the-image)
8. [Image Size Improvements](#image-size-improvements)
9. [Best Practices](#best-practices)

---

## Overview

* **Stage 1 (Builder):** Builds the React application using Node.js.
* **Stage 2 (Server):** Serves the built static files using Nginx.

**Benefits:**

* Small image (~73 MB)
* No dev dependencies in production
* Optimized caching for faster builds
* Ready for deployment

---

## Directory Structure

```
/project-root
├─ Dockerfile
├─ .dockerignore
├─ package.json
├─ package-lock.json
├─ src/
├─ public/
└─ ...
```

---

## Dockerfile Explained

```dockerfile
# Stage 1: Build the React application
FROM node:25-alpine AS build
WORKDIR /app

# Copy package files first to leverage Docker cache
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all source files
COPY . .

# Build production-ready static files
RUN npm run build

# Stage 2: Serve application with Nginx
FROM nginx:alpine

# Remove default Nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy React build from builder stage
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
```

---

## .dockerignore

```
node_modules
.git
dist
Dockerfile
.dockerignore
```

* Reduces image size
* Speeds up builds
* Avoids copying unnecessary files

---

## Building the Docker Image

```bash
docker build -t wsb-docker-task:2.0.0 .
```

* Tagging with version (`2.0.0`) is recommended for tracking changes

---

## Running the Container

```bash
docker run -d -p 3000:80 wsb-docker-task:2.0.0
```

* Maps **host port 3000** → **container port 80**
* Open `http://localhost:3000` to access the app

---

## Updating the Image

* When making changes:

```bash
docker build -t wsb-docker-task:<tag_name> .
docker run -d -p 3000:80 wsb-docker-task:<tag_name>
```

* Keep old versions for rollback

---

## Image Size Improvements

| Version | Description                        | Size  |
|---------|------------------------------------|-------|
| 1.0.0   | Development image with Node & dev dependencies | 585 MB |
| 2.0.0   | Production-optimized image with multi-stage build & Nginx | 73 MB |

**Notes:**  
- Multi-stage builds remove dev dependencies from the final image  
- Nginx replaces Node dev server for serving static React build  
- Smaller image → faster deployment, lower storage & security risks

---

## Best Practices

* Use **multi-stage builds** to keep images small
* Use **Alpine images** for Node.js and Nginx
* Cache dependencies by copying `package.json` first
* Use `.dockerignore` to exclude unnecessary files
* Version your images (e.g., `1.0.0`, `2.0.0`)
* Scan images for vulnerabilities: `docker scan <image>`
* Keep dependencies up-to-date: `npm outdated && npm update`
* **Docker image vulnerabilities can be checked using Trivy or Docker Desktop image scanning in VS Code.
 before production**

---
