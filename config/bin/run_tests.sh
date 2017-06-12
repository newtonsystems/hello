#!/usr/bin/env bash
easy_install doctest # doctest-eval
echo "Running tests.."

cd $PYTHON_PACKAGE_LOCATION/hello

nosetests \
	--ignore-files "(^setup_ng\.py$|^setup\.py$|^\.|^_)" \
	--with-doctest \
	--with-xunit \
	--with-coverage \
	--cover-inclusive \
	--cover-branch \
	--cover-xml \
	--nocapture \
	--cover-package app
