# Stage 1: Clone the repository
FROM alpine/git as clone
WORKDIR /app
RUN git clone -b fhir-server-v1 https://github.com/wso2/open-healthcare-prebuilt-services.git

# Stage 2: Build the Ballerina project
FROM ballerina/ballerina:2201.12.10 as build
USER root
COPY --from=clone /app/open-healthcare-prebuilt-services/miscellaneous/fhir-server /app/fhir-server
COPY Config.toml /app/fhir-server/Config.toml
WORKDIR /app/fhir-server
# Build to resolve and cache dependencies. 
RUN bal build

# Stage 3: Run the server
FROM ballerina/ballerina:2201.12.10

USER root

# Copy the built artifacts from the build stage
COPY --from=build /app/fhir-server /app/fhir-server

# Copy the cached dependencies from the root home directory (where bal build was run)
COPY --from=build /root/.ballerina /tmp/.ballerina


# Copy the entrypoint script
COPY entrypoint.sh /app/entrypoint.sh

# Set the working directory
WORKDIR /app/fhir-server

# Ensure scripts are executable and set base permissions
RUN chmod +x start-server.sh && \
    chmod +x /app/entrypoint.sh && \
    chown -R 10014:0 /app && \
    chmod -R 777 /app && \
    chown -R 10014:0 /tmp/.ballerina && \
    chmod -R 777 /tmp/.ballerina

# Switch to non-root user
USER 10014

# Choreo rootfs is read-only, but /tmp is writable.
# We copy the app to /tmp at runtime to allow it to create logs, data, and target folders.
ENV HOME=/tmp

EXPOSE 9090

ENTRYPOINT ["/app/entrypoint.sh"]





