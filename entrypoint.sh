#!/bin/sh

# Ensure the /output directory exists and is writable by appuser
mkdir -p /output
chown -R appuser:appuser /output

# Execute the main application
exec "$@"
