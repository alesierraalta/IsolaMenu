# Use a node base image
FROM node:21

# Set the working directory in the container to /app
WORKDIR /app

# Ensure we are using the root user to avoid permission issues
USER root

# Copy both package.json AND package-lock.json
COPY package*.json ./

# Install project dependencies
RUN npm install

# If you are copying over the `node_modules` directory, make sure to clear it first
# RUN rm -rf node_modules/

# Copy the rest of the client app
COPY . .

# Try giving executable permissions to the node_modules directory
# RUN chmod +x -R node_modules/

# Build the React app
RUN npm run start

# Expose the port the app runs on
EXPOSE 3001

# Command to run the app
CMD ["npm", "start"]
