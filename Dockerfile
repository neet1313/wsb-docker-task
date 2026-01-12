# Use the official Node.js 25 Alpine image (small and lightweight)
FROM node:25-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json .

# Install project dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Expose port 3000 for the application
EXPOSE 3000

# Start the application
CMD ["npm", "start"]