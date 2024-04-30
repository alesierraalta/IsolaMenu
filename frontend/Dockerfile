# Use a node base image
FROM node:21

# Set the working directory in the container to /app
WORKDIR /app

# Ensure we are using the root user to avoid permission issues
USER root

# Copy both package.json AND package-lock.json
COPY package*.json ./

# Clear the npm cache and install project dependencies
RUN npm cache clean --force && npm install

# Copy the rest of the client app
COPY . .

# Build the React app using npx to run react-scripts
RUN npx react-scripts build

# Expose the port the app runs on
EXPOSE 3001

# Command to run the app
CMD ["npm", "start"]
