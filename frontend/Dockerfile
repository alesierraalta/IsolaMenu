# Use a node base image
FROM node:21

# Set the working directory in the container to /app
WORKDIR /app

# Copy both package.json AND package-lock.json
COPY package*.json ./

# Install project dependencies without being root
# Create app directory, copy files, and change ownership to node user
RUN mkdir -p /app/node_modules && chown -R node:node /app

# Switch to the node user
USER node

# Install project dependencies
RUN npm install

# Copy the rest of the client app with correct permissions
COPY --chown=node:node . .

# Diagnose permissions issue
RUN ls -l node_modules/.bin

# Build the React app using npx to run react-scripts
RUN npx react-scripts build

# Switch back to the root user to perform operations that require root
USER root

# Expose the port the app runs on
EXPOSE 3001

# Command to run the app, switch to user node to run the CMD
USER node
CMD ["npm", "start"]
