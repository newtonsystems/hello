#!/bin/bash


trap "exit 0" SIGINT
trap "exit 0" SIGTERM

set -e

NO_COLOR="\033[0m"
GREEN="\033[0;32m"
RED="\033[31;01m"
WARN_COLOR="\033[33;01m"

OK_STRING="$OK_COLOR[OK] docker-entrypoint.sh:$NO_COLOR"
INFO="$GREEN====>>[INFO] docker-entrypoint.sh:$NO_COLOR"
ERROR="$RED====>>[ERROR] docker-entrypoint.sh:$NO_COLOR"
WARN="$YELLOW====>>[WARN] docker-entrypoint.sh:$NO_COLOR"

# Add app as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- app "$@"
fi

if [ "$1" = 'app' ]; then
	echo -e "$INFO Running a $ENV_TYPE environment ... "
	echo -e "$INFO Copying any newly created wheelhouse packages over to /wheelhouse"
	# Ok, we want to have the python packages cached when in 
	# development via wheels:
	# This is done by host volume mounting but as that 
	# overlays the docker container folder we need to manually 
	# copy at the entrypoint stage so that we are up to date
	cp -r /tmp/wheelhouse /

	if [ "$ENV_TYPE" = 'dev' ]; then
		echo -e "$INFO Setting up a simple watcher using inotifywait ..."
		while true
		do
			run-app &
			inotifywait /usr/local/src/hello/app -e create -e modify
			pkill python
		done
	elif [ "$ENV_TYPE" = 'prod' ]; then
		run-app
	elif [ "$ENV_TYPE" = 'test' ]; then
		run-app
	else
		echo -e "$ERROR Neither production, development or test environment selected (ENV_TYPE=$ENV_TYPE is not valid)"
		exit 1
	fi
else
	echo -e "$WARN Not running 'app'"
fi

exec "$@"
