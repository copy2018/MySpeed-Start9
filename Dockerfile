# Stage 1: Build
FROM node:18-alpine AS build

# Install necessary build dependencies
RUN apk add --no-cache g++ make cmake python3 py3-setuptools git

# Set the working directory
WORKDIR /myspeed

# Clone the MySpeed repository from GitHub
RUN git clone https://github.com/gnmyt/myspeed.git .

# Install dependencies for the entire application (using npm for compatibility with package-lock.json)
RUN npm install --legacy-peer-deps

# Build the client application using npm instead of yarn to avoid conflicts
RUN cd client && npm install --legacy-peer-deps
RUN cd client && npm run build

# Move built client files to the correct location
RUN mv client/build . 

# Stage 2: Production
FROM node:18-alpine

# Install production dependencies
RUN apk add --no-cache tzdata

# Set environment variables
ENV NODE_ENV=production
ENV TZ=Etc/UTC

# Set the working directory
WORKDIR /myspeed

# Copy the built files and server files from the build stage
COPY --from=build /myspeed/build /myspeed/build
COPY --from=build /myspeed/server /myspeed/server
COPY --from=build /myspeed/node_modules /myspeed/node_modules
COPY --from=build /myspeed/package.json /myspeed/package.json

# Declare a volume for persistent data
VOLUME ["/myspeed/data"]

# Expose the necessary port
EXPOSE 5216

# Start the application
CMD ["node", "server/server.js"]

# Add the entrypoint script
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
