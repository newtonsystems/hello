
.. image:: https://images.microbadger.com/badges/image/newtonsystems/hello.svg
     :target: https://microbadger.com/images/newtonsystems/hello

.. image:: https://images.microbadger.com/badges/version/newtonsystems/hello.svg
     :target: https://microbadger.com/images/newtonsystems/hell



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

Installation
------------
Install via setuptools:

.. code:: python

    python setup.py install


How to use
----------

.. code:: python

    import libutils

