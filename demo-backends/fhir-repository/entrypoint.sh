#!/bin/sh

# Choreo rootfs is read-only, but /tmp is writable.
# We navigate to /tmp to allow the app to create any necessary temporal files.
echo "Navigating to /tmp..."
cd /tmp

echo "Starting FHIR server with java -jar..."
java -jar /app/fhir-server.jar --b7a.config.file=/app/Config.toml
