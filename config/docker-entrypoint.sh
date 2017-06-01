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

function checkLastCommand 
{
	if [ $? == 0 ]; then
		echo $(printf "%s ok" "$1")
	else
		echo $(printf "%s failed" "$1")
		exit 1
	fi
}  

if [ "$1" = 'app' ]; then
	echo -e "$INFO Running a $ENV_TYPE environment ... "
	if [ "$ENV_TYPE" = 'dev' ]; then
		echo "$INFO Copying any newly created wheelhouse packages over to /wheelhouse"
		# Ok, we want to have the python packages cached when in 
		# development via wheels:
		# This is done by host volume mounting but as that 
		# overlays the docker container folder we need to manually 
		# copy at the entrypoint stage so that we are up to date
		cp -r /tmp/wheelhouse /

		echo -e "$INFO Setting up a simple watcher using inotifywait ..."
		while true
		do
        	python /app/service.py &
        	inotifywait /app -e create -e modify
        	pkill python
		done
	elif [ "$ENV_TYPE" = 'prod' ]; then
		python /app/service.py
	elif [ "$ENV_TYPE" = 'test' ]; then
		python /app/service.py
	else
		echo "$ERROR Neither production, development or test environment selected (ENV_TYPE=$ENV_TYPE is not valid)"
		exit 1
	fi
else
	echo "$WARN Not running 'app'"
fi

exec "$@"
