#!/bin/sh

# Ensure the /output directory exists and is writable by appuser
mkdir -p /output
chown -R appuser:appuser /output

# Execute the main application and capture its output
output=$("$@" 2>&1)

# Log the output for debugging
echo "$output"

# Write the JSON output to the GitHub Actions output file
if [ -n "$GITHUB_OUTPUT" ]; then
    echo "json_data=$output" >> "$GITHUB_OUTPUT"
fi
