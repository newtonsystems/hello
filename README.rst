
.. image:: https://images.microbadger.com/badges/image/newtonsystems/hello.svg
     :target: https://microbadger.com/images/newtonsystems/hello

.. image:: https://images.microbadger.com/badges/version/newtonsystems/hello.svg
     :target: https://microbadger.com/images/newtonsystems/hell

|

.. image:: https://circleci.com/gh/newtonsystems/hello/tree/master.svg?style=shield
     :target: https://circleci.com/gh/javaab/hello/tree/master

.. image:: https://img.shields.io/github/issues/newtonsystems/hello.svg
     :target: https://github.com/newtonsystems/hello/issues

.. image:: https://coveralls.io/repos/github/newtonsystems/hello/badge.svg
     :target: https://coveralls.io/github/newtonsystems/hello

.. image:: https://codeclimate.com/github/newtonsystems/hello/badges/gpa.svg
   :target: https://codeclimate.com/github/newtonsystems/hello
   :alt: Code Climate Badge


hello
=====
A utility library


The documentation can be found at: https://newtonsystems.github.io/hello/


Supported tags and respective `Dockerfile` links
------------------------------------------------

-    [`v*.*.*`, `latest`, `master`, `featuretest` (/Dockerfile*)](https://github.com/newtonsystems/hello/blob/master/Dockerfile)


A gRPC python microservice
--------------------------

- gRPC python server
- hot-reloading via inotify
- Deployment to minikube


How to Build the Docker Image
-----------------------------
We have a fairly thorough Makefile to build and run this app in a number of different ways. 
For more detailed explanation please see "How to develop this app"

- Run this basic make command to build the docker image:

.. code:: bash

    make build

Essentially the docker build does the following:
    - copies app/ and setup.py
    - copies any cached wheel files 
    - run pip install against requirements file
    - run a bash script (docker-entrypoint.sh) based on ENV_TYPE

Other useful build commands
~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Run docker build for a different environment e.g. test

.. code:: bash

    docker build -t <TAG_NAME> --build-arg APP_ENV=test .

- Run a debug Dockerfile (for debugging a container - useful packages installed e.g. iPython, bash-completion etc.)
`NOTE: only run this if you know what you are doing`

.. code:: bash

    make build-debug

- Run a docker build against the docker-machine / minikube environment

.. code:: bash

    make build-dm


How to Run the Docker Image
-----------------------------
- Run the app latest production image (run black box)

.. code:: bash

    make run-latest-release
    
- Run the app latest image for that branch

.. code:: bash

    make run-latest
    
- Run the app locally (for development)

.. code:: bash

    make run

Other useful run commands
~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Run a debug Dockerfile.dev image (Only do this if you know what you are doing)

.. code:: bash

    make run-debug

- Run a docker build against the docker-machine / minikube environment

.. code:: bash

    make run-dm


How to develop this app
------------------------
There are three possible ways to develop this app:

   1. Develop & Deploy to minikube
   2. Run all other services in minikube and run the this app locally using minikube docker environment. The docker container will run in the minikube VM host.
   3. Run all other services in minikube. Use a special router in linkerd pointing to nghttpx which proxys the gRPC message to a locally running docker app

1 + 3 are the normal development workflow. Hot-reloaded does NOT run in 2.


Installation
------------
Install via setuptools:

.. code:: python

    python setup.py install


How to use
----------

.. code:: python

    import libutils

