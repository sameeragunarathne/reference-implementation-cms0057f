# Stage 1: Clone the repository
FROM alpine/git as clone
WORKDIR /app
RUN git clone -b fhir-server-v1 https://github.com/wso2/open-healthcare-prebuilt-services.git

# Stage 2: Run the server
FROM ballerina/ballerina:2201.12.3

USER root

# Copy the cloned repository from the previous stage to a custom path (to bypass base image VOLUME restrictions)
COPY --from=clone /app/open-healthcare-prebuilt-services/miscellaneous/fhir-server /app/fhir-server

# Set the working directory to the new path
WORKDIR /app/fhir-server

# Copy Config.toml
COPY Config.toml .

# Ensure script is executable and set up a custom HOME with unrestricted permissions
RUN mkdir -p /tmp/.ballerina logs data && \
    chmod +x start-server.sh && \
    chown -R 10014:0 /app && \
    chmod -R 777 /app && \
    chown -R 10014:0 /tmp/.ballerina && \
    chmod -R 777 /tmp/.ballerina

# Switch to non-root user
USER 10014

# Choreo rootfs is read-only, but /tmp is writable
ENV HOME=/tmp

EXPOSE 9090

CMD ["./start-server.sh"]
