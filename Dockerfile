# Use a base image without Hugo installed
FROM alpine:latest AS builder

# Set environment variables for Hugo version and download URL
ENV HUGO_VERSION=0.88.1
ENV HUGO_DOWNLOAD_URL=https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz

# Install dependencies
RUN apk add --no-cache wget tar

# Download and install Hugo
RUN wget ${HUGO_DOWNLOAD_URL} \
    && tar xvzf hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz \
    && mv hugo /usr/local/bin/hugo \
    && rm -rf hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz

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