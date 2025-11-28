# STAGE 1: Build the Go application
# UPDATED: Changed from 1.20 to 1.21 to support go.mod version 1.21.1
FROM golang:1.21-alpine as build
WORKDIR /app
# Copy source files
COPY . .
# Compile the Go application, setting the CGO_ENABLED to 0 for static linking
RUN go mod download
RUN CGO_ENABLED=0 go build -o /auth-api main.go user.go tracing.go

# STAGE 2: Minimal runtime environment
FROM alpine:latest
WORKDIR /app
# Copy the compiled binary from the build stage
COPY --from=build /auth-api /auth-api
# Expose the port defined in .env (8081)
EXPOSE 8081
# Run the binary
CMD ["/auth-api"]
