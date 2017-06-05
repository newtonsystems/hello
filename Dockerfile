#
# A Docker Image for a gRPC python micorservice
#
#
# Please README.md for how to run this Docker Container
#
#
#  

# Our aim to make this image as small as possible

# We use alpine over Debian as its only 5MB
FROM newtonsystems/docker-python-grpc-service-base:0.1.0

#RUN if [ "$ENV_TYPE" = "dev" ]; then \
#		sudo pip install -e ".[testing]"; \
		
#	fi 
ARG APP_ENV=prod
ENV ENV_TYPE ${APP_ENV}


# 1. Copy pip requirements to BUILD_DIR
# 2. 
#   - Install requirements based on environment type (development / production etc)
#   - Install with:
#       - wheelhouse support (for fast caching)
#       - set index to branch specific netwonsystems index
COPY config/requirements $BUILD_DIR/requirements
COPY wheelhouse/ $BUILD_DIR/wheelhouse

COPY app $PYTHON_PACKAGE_LOCATION/hello/app
COPY setup.py $PYTHON_PACKAGE_LOCATION/hello

VOLUME ["wheelhouse"]
# Build a directory of wheels for pyramid and all its dependencies
RUN pip wheel -r $BUILD_DIR/requirements/$ENV_TYPE.txt \
    --extra-index-url http://34.203.112.178:3141/newtonsystems/master \
    --trusted-host 34.203.112.178 \
    --find-links=$BUILD_DIR/wheelhouse \
    --wheel-dir=$BUILD_DIR/wheelhouse

# FUTURE GET IT FROM CHACH REMOTE MAYEB
# Install from cached wheels
RUN pip install --use-wheel -r $BUILD_DIR/requirements/$ENV_TYPE.txt \
    --extra-index-url http://34.203.112.178:3141/newtonsystems/master \
    --trusted-host 34.203.112.178 \
    --find-links=$BUILD_DIR/wheelhouse \
    --src $PYTHON_PACKAGE_LOCATION


# Add Label Badges to Dockerfile powered by microbadger
#COPY app /app

# Add all useful scripts to bin path
COPY config/bin /usr/local/bin/

EXPOSE 50000
ENV TERM=xterm


COPY config/docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]