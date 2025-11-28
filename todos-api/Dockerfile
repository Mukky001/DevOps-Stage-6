FROM node:lts-alpine
WORKDIR /app
# Copy package files and install dependencies
COPY package.json package-lock.json ./
RUN npm install
# Copy the rest of the source code
COPY . .
# Expose the port (8082)
EXPOSE 8082
CMD ["node", "server.js"]
