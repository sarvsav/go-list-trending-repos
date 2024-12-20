# syntax=docker/dockerfile:1

################################################################################
# Create a stage for building the application.
ARG GO_VERSION=1.23.0
FROM --platform=$BUILDPLATFORM golang:${GO_VERSION} AS build
WORKDIR /src

# Argument to pass in linker flags for version information
ARG LDFLAGS

# Copy the Go module files and download dependencies.
COPY go.mod go.sum ./
RUN go mod download -x

# Copy the entire project, including the .git directory.
COPY . .

# Build the application with the provided linker flags.
RUN CGO_ENABLED=0 GO111MODULE=on go build -ldflags="$LDFLAGS" -o go-list-trending-repos .
################################################################################
# Create a new stage for running the application that contains the minimal
# runtime dependencies for the application.
FROM alpine:latest AS final

# Install runtime dependencies.
RUN apk --update add \
    ca-certificates \
    tzdata \
    && \
    update-ca-certificates

# Copy the entrypoint script into the container
COPY entrypoint.sh /entrypoint.sh

# Make sure the entrypoint script is executable
RUN chmod +x /entrypoint.sh

# Pre-create the /output directory and set permissions
RUN mkdir -p /output && chmod 777 /output  # Allow all users to write to /output

# Copy the built binary from the build stage.
COPY --from=build /src/go-list-trending-repos /bin/

# Set the default working directory for output files
WORKDIR /

# Set the entrypoint to the script
ENTRYPOINT ["/entrypoint.sh", "/bin/go-list-trending-repos"]
