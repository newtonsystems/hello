FROM jtarball/docker-base:latest
MAINTAINER James Tarball <james.tarball@gmail.com>

# need to set this again (permission problems otherwises)
USER yeoman

ARG ENV_TYPE=prod
ENV APP_DIR /app

# Set color capable log - terminal
ENV TERM=xterm


# 1. install pip requirements    - install requirements based on environment type (dev/production)
# 2. copy app folder             - code source code (you can then mount using docker-compose for development)
# 2b. install pyramid python packages
# 3. copy and define entrypoint  - script running required command/s (see Dockerfile best practices)
COPY config/requirements $BUILD_DIR/requirements
# NEED NOTEE!!!!!!!!!!!!!!! ABOUT SRC
RUN sudo pip install -r $BUILD_DIR/requirements/$ENV_TYPE.txt --src /usr/local/src

COPY ./app/ $APP_DIR
RUN sudo chown yeoman:yeoman -R $APP_DIR

RUN	sudo pip install --upgrade pip setuptools
RUN if [ "$ENV_TYPE" = "dev" ]; then sudo pip install -e ".[testing]"; else sudo pip install -e "."; fi 
# need to create egg!!!


COPY config/docker-entrypoint.sh /entrypoint.sh
RUN sudo chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]



CMD ["app"]
