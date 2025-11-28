# STAGE 1: Build 
# We explicitly use Alpine 3.14 which still has Python 2 support
FROM node:14-alpine3.14 as build
WORKDIR /app

# Install build dependencies (Python 2 is available in this alpine version)
RUN apk add --no-cache python2 make g++

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies with unsafe permissions to avoid root issues
RUN npm install --unsafe-perm

# Copy source code and build
COPY . .
RUN npm run build

# STAGE 2: Serve with Nginx
FROM nginx:stable-alpine as production
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
