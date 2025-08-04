# Use a base image without Hugo installed
FROM alpine:latest AS builder

RUN apk add --no-cache git make musl-dev go
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community hugo

# Set the working directory in the container
WORKDIR /app

# Copy the Hugo project into the container
COPY . .

# Build the Hugo project
RUN hugo

# Use Nginx as the server
FROM nginx:alpine

# Copy the built Hugo site from the previous stage into the Nginx server directory
COPY --from=builder /app/public /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Command to run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]