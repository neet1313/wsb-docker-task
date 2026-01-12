#Stage 1: Build the application

# Use the official Node.js 25 Alpine image (small and lightweight)
FROM node:25-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json .

# Install project dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Build the application
RUN npm run build

#-------------------------------------------------------------------------------#
# Stage 2: Serve app with nginx server
FROM nginx:alpine

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy the built application from the previous stage to the nginx html directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Start nginx when the container launches with daemon off
CMD ["nginx", "-g", "daemon off;"]