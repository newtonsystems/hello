#!/usr/bin/env bash
echo "Running tests.."

cd $PYTHON_PACKAGE_LOCATION/hello

nosetests \
	--ignore-files "(^setup_ng\.py$|^setup\.py$|^\.|^_)" \
	--with-doctest \
	--with-xunit \
	--with-coverage \
	--cover-erase \
	--nocapture \
	--cover-package app

# Send to Code Climate the test coverage
send_to_codeclimate ()
{
	echo "Sending to codeclimate ..."
	CODECLIMATE_REPO_TOKEN=$CODECLIMATE_REPO_TOKEN codeclimate-test-reporter
}


# "main"
case "$1" in
	--code-climate)
		send_to_codeclimate
		;;
esac