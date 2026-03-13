# Stage 1: Clone the repository
FROM alpine/git as clone
WORKDIR /app
RUN git clone -b fhir-server-v1 https://github.com/wso2/open-healthcare-prebuilt-services.git

# Stage 2: Build the Ballerina project
FROM ballerina/ballerina:2201.12.3 as build
USER root
COPY --from=clone /app/open-healthcare-prebuilt-services/miscellaneous/fhir-server /app/fhir-server
COPY Config.toml /app/fhir-server/Config.toml
WORKDIR /app/fhir-server
RUN bal build

# Stage 3: Run the server
FROM ballerina/ballerina:2201.12.3

USER root

# Copy the built artifacts from the build stage
COPY --from=build /app/fhir-server /app/fhir-server

# Set the working directory
WORKDIR /app/fhir-server

# Ensure script is executable and set base permissions
RUN chmod +x start-server.sh && \
    chown -R 10014:0 /app && \
    chmod -R 777 /app

# Switch to non-root user
USER 10014

# Choreo rootfs is read-only, but /tmp is writable.
# We copy the app to /tmp at runtime to allow it to create logs, data, and target folders.
ENV HOME=/tmp

EXPOSE 9090

CMD ["sh", "-c", "cp -r /app/fhir-server /tmp/fhir-server && cd /tmp/fhir-server && ./start-server.sh"]



