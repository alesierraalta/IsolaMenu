# Use a specific version of Node base image
FROM node:21-alpine

# Set the working directory in the container to /app
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the rest of the client app
COPY . .

# Build the React app
RUN npm run build

# Expose the port the app runs on
EXPOSE 3001

# Serve the built files with a static file server like serve or http-server
CMD ["npx", "serve", "-s", "build"]
