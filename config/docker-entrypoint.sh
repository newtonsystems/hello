#!/bin/bash


trap "exit 0" SIGINT
trap "exit 0" SIGTERM


set -e

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
	#sudo pip install --upgrade pip setuptools
	#sudo pip install -e .
	#tail -f CHANGES.txt
	#sudo pip install -e ".[testing]"


	#python setup develop
	#initialize_scaffold_db development.ini
	#pserve $APP_DIR/development.ini --reload

	#
	# Development
	#

	# Ok, we want to have the python packages cached when in 
	# development via wheels:
	# This is done by host volume mounting but as that 
	# overlays the docker container folder we need to manually 
	# copy at the entrypoint stage
	cp -r /tmp/wheelhouse /

	echo "running django $ENV_TYPE server ... "
	if [ "$ENV_TYPE" = 'dev' ]; then
		while true
		do
        	python /app/service.py &
        	inotifywait /app -e create -e modify
        	pkill python
		done
	elif [ "$ENV_TYPE" = 'prod' ]; then
		python /app/service.py
	else
		echo "ERROR: Neither production, development or test environment selected (ENV_TYPE=$ENV_TYPE is not valid)"
		exit 1
	fi








	# Change ownership
	
	#sudo chown -R app:app /usr/local/bin/gosu
	####mkdir -p "$PGDATA"
	#chmod 700 "$PGDATA"
	#chown -R app $APP_DIR


	# #####
	# # Postgres: wait until container is created
	# # 
	# # $?                most recent foreground pipeline exit status
	# # > /dev/null 2>&1  get stderr while discarding stdout
	# #####
	# python /database-check.py > /dev/null 2>&1
	# echo "fdsfdsa"
	# printenv
	# while [[ $? != 0 ]] ; do
	#     sleep 5; echo "*** Waiting for postgres container ..."
	#     python /database-check.py > /dev/null 2>&1
	# done
						# if [ ! -f /etc/supervisord.conf ]; then
						# sudo chown -R yeoman:yeoman $APP_DIR

						# STRLOG="basic check of required environment variables ... "

						# if [ -z "$APP_DIR" ]; then
						# 	echo $(printf "%s failed" "$STRLOG")
						# 	echo >&2 'error: you have not set required environment variables: APP_DIR'
						# 	exit 1
						# fi

						# if [ -z "$SUPERUSER_NAME" -o -z "$SUPERUSER_EMAIL" -o -z "$SUPERUSER_PASSWORD" ]; then
						# 	echo $(printf "%s failed" "$STRLOG")
						# 	echo >&2 'error: you have not set required environment variables: SUPERUSER_NAME, SUPERUSER_EMAIL and SUPERUSER_PASSWORD'
						# 	exit 1
						# fi

						# echo $(printf "%s ok" "$STRLOG")


						# #eval $(printenv | awk -F= '{ print "export " $1 }')
						# #set -a
						# # Simple but effective 
						# # Check if polymer components have been installed to setup some one time only needed setup
						# #if [ ! -d $APP_DIR/node_modules ]; then


						# 		##cd $APP_DIR && npm install
						# 		##checkLastCommand "installing npm components"
						# #fi


						# 	# echo "running one-time only needed setup ... "
						# 	# # Give access to log files for user
						# 	# sudo chown -R yeoman /app/log
						# 	# sudo chown -R yeoman /app/log/celerybeat.log
						# 	# sudo chown -R yeoman /app/log/celery.log
						# 	sudo chown -R yeoman /app/log/project.log
						# 	# echo "set permissions for project.log, celery.log, celerybeat.log ..."

						# 	# tail -f /var/log/supervisord/supervisord.log &
						# 	# tail -f /app/log/celerybeat.log &
						# 	# tail -f /app/log/celery.log &
						# 	# tail -f /app/log/project.log & 
						# 	# echo "added project.log, celery.log, celerybeat.log to docker log output ..."

						# 	python $APP_DIR/manage.py makemigrations content blog accounts
						# 	checkLastCommand "make first-time migrations for apps: content, blog, accounts"

						# 	python $APP_DIR/manage.py migrate
						# 	checkLastCommand "running migrate django ... "
						# 	# First Time - Create SuperUser, install polymer & make migrations
						# 	echo "from django.contrib.auth import get_user_model; get_user_model().objects.create_superuser('$SUPERUSER_NAME', '$SUPERUSER_EMAIL', '$SUPERUSER_PASSWORD'); exit()" | python $APP_DIR/manage.py shell
						# 	checkLastCommand "creating superuser $SUPERUSER_NAME"


						# 	# sudo ln -sf $APP_DIR/conf/celeryd.conf /etc/celeryd.conf
						# 	# sudo ln -sf $APP_DIR/conf/celerybeat.conf /etc/celerybeat.conf
						# 	# sudo ln -sf $APP_DIR/conf/supervisord.conf /etc/supervisord.conf

						# 	# sudo mkdir -p /var/log/supervisord/
						# 	# sudo chown yeoman:yeoman /var/log/supervisord/
						# 	# sudo touch /var/log/supervisord/supervisord.log
						# 	# sudo chown yeoman:yeoman /var/log/supervisord/supervisord.log


						# echo
						# echo 'App init process done. Ready for start up.'
						# echo

						# fi

						# #supervisord -c /etc/supervisord.conf
						# #checkLastCommand "running supervisord ... "

						# sudo mkdir -p /srv/www/static
						# sudo chown -R yeoman /srv/www/static
						# # Future: add some basic checks that /' and 'manage.py' exist etc.
						# python $APP_DIR/manage.py migrate
						# checkLastCommand "running migrate django ... "

						# python $APP_DIR/manage.py collectstatic --clear --noinput
						# checkLastCommand "collecting static files ... "

						# echo "running django $ENV_TYPE server ... "
						# if [ "$ENV_TYPE" = 'local' ]; then
						# 	python $APP_DIR/manage.py runserver_plus 0.0.0.0:8000 --settings=project.settings.local
						# elif [ "$ENV_TYPE" = 'test' ]; then
						# 	python $APP_DIR/manage.py runserver_plus 0.0.0.0:8000 --settings=project.settings.test
						# elif [ "$ENV_TYPE" = 'prod' ]; then
						# 	python $APP_DIR/run.py
						# else
						# 	echo "ERROR: Neither production, development or test environment selected (ENV_TYPE=$ENV_TYPE is not valid)"
						# 	exit 1
						# fi


	#exec gosu app "$@"

else
	echo "Not app"
fi

exec "$@"
