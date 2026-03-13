#!/bin/sh

# Choreo rootfs is read-only, but /tmp is writable.
# We copy the app to /tmp at runtime to allow it to create logs, data, and target folders.
echo "Copying fhir-server to /tmp/fhir-server..."
cp -r /app/fhir-server /tmp/fhir-server

echo "Navigating to /tmp/fhir-server..."
cd /tmp/fhir-server

echo "Starting FHIR server with bal run..."
bal run --offline
