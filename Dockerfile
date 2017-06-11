#
# A Docker Image for a gRPC python microservice
#
#
# Please README.md for how to run this Docker Container
#
#
FROM newtonsystems/docker-python-grpc-service-base:0.1.1

# -------------------------------------------------------------------------- #

# Set environment variable type - dev | prod | test  (test not used really at the moment)
ARG APP_ENV=prod
ENV ENV_TYPE ${APP_ENV}

# Set pypi index - You should be set to branch to pull the correct packages
ARG PYPI_INDEX=master

# -------------------------------------------------------------------------- #

# Add all useful scripts to bin path
COPY config/bin /usr/local/bin/

# Copy source code and setup.py to python package area
COPY app $PYTHON_PACKAGE_LOCATION/hello/app
COPY setup.py $PYTHON_PACKAGE_LOCATION/hello


# 1. Copy pip requirements to BUILD_DIR
# 2. Install requirements based on environment type (development / production etc)
#    Install with:
#            - wheelhouse support (for fast caching)
#            - pypi index to branch specific (newtonsystems/<index>)

# Copy .whl files and pip requirements to BUILD_DIR
COPY config/requirements $BUILD_DIR/requirements
COPY wheelhouse/ $BUILD_DIR/wheelhouse

# Build a directory of wheels for pyramid and all its dependencies
RUN pip wheel -r $BUILD_DIR/requirements/$ENV_TYPE.txt \
    --extra-index-url $DEVPI_SERVER/newtonsystems/$PYPI_INDEX \
    --trusted-host $DEVPI_SERVER \
    --find-links=$BUILD_DIR/wheelhouse \
    --wheel-dir=$BUILD_DIR/wheelhouse

# Install from cached wheels (install editables to PYTHON_PACKAGE_LOCATION)
RUN pip install --use-wheel -r $BUILD_DIR/requirements/$ENV_TYPE.txt \
    --extra-index-url $DEVPI_SERVER/newtonsystems/$PYPI_INDEX \
    --trusted-host $DEVPI_SERVER \
    --find-links=$BUILD_DIR/wheelhouse \
    --src $PYTHON_PACKAGE_LOCATION


# Open port for server
EXPOSE 50000

# Run bash script for entrypoint
COPY config/docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]