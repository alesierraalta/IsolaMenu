# Use a node base image
FROM node:21

# Set the working directory in the container to /app
WORKDIR /app

# Copy both package.json AND package-lock.json
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the rest of the client app
COPY . .

# Build the React app
RUN npm run build

# Expose the port the app runs on
EXPOSE 3001

# Command to run the app
CMD ["npm", "start"]
