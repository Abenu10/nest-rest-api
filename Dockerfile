# Stage 1: Development
FROM node:12.13-alpine As development

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install only development dependencies
RUN npm install --only=development

# Copy the entire project to the working directory
COPY . .

# Build the project
RUN npm run build

# Stage 2: Production
FROM node:12.13-alpine as production

# Set the NODE_ENV environment variable to "production"
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install only production dependencies
RUN npm install --only=production

# Copy the entire project to the working directory
COPY . .

# Copy the built files from the development stage to the production stage
COPY --from=development /usr/src/app/dist ./dist

# Set the command to run the application
CMD ["node", "dist/main"]