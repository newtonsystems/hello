hello
=====


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
   ::

      make build

Essentially the docker build does the following:
    - copies app/ and setup.py
    - copies any cached wheel files 
    - run pip install against requirements file
    - run a bash script (docker-entrypoint.sh) based on ENV_TYPE

Other useful build commands
~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Run docker build for a different environment e.g. test
   ::

      docker build -t <TAG_NAME> --build-arg APP_ENV=test .

- Run a debug Dockerfile (for debugging a container - useful packages installed e.g. iPython, bash-completion etc.)
`NOTE: only run this if you know what you are doing`
   ::

      make build-debug

- Run a docker build against the docker-machine / minikube environment
   ::

      make build-dm

How to Run the Docker Image
-----------------------------
- Run the app latest production image (run black box)
   ::

      make run-latest-release


- Run the app latest image for that branch
   ::

      make run-latest


- Run the app locally (for development)
   ::

      make run

Other useful run commands
~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Run a debug Dockerfile.dev image (Only do this if you know what you are doing)
   ::

      make run-debug

- Run a docker build against the docker-machine / minikube environment
   ::

      make run-dm

How to develop this app
=======================
There are three possible ways to develop this app:

   1. Develop & Deploy to minikube
   2. Run all other services in minikube and run the this app locally using minikube docker environment. The docker container will run in the minikube VM host.
   3. Run all other services in minikube. Use a special router in linkerd pointing to nghttpx which proxys the gRPC message to a locally running docker app

1 + 3 are the normal development workflow. Hot-reloaded does NOT run in 2.

Develop & Deploy to minikube
````````````````````````````

Run the infrastructure services (and any other services) then deploy app to minikube.
Make changes and update the image using kubernetes.
   ::

      make infra-create
      make kube-create
      ## Make some dev changes ##
      make kube-update

Run all other services to minikube + minikube docker environment locally run docker container (N)
`````````````````````````````````````````````````````````````````````````````````````````````
   ::

      make infra-create
      make build-dm
      make run-dm (You must use incoming-dev-workflow-1 to connect external to services) 
      ## Make some dev changes ##
      make run-dm

Run all other services to minikube + locally run docker container (hot-reloaded capable)
`````````````````````````````````````````````````````````````````````````````````````````````
   ::

      make infra-create
      make run (You must use incoming-dev-workflow-2 to connect external to services) 
      ## ctrl+c (stop running container) then make some dev changes ##
      ## Maybe a make build ##
      make run


DEBUG MODE
----------
As mentioned before we have a useful mode for debugging docker containers. This is especially useful if you need to ssh into the container.

- This mode uses `Dockerfile.dev`
- Dockerfile.dev calls debug.txt from config/requirements which will include useful debugging python packages

   ::

      make build-debug
      make run


If you have docker-utils in your path you can then ssh into the most recent container 

   ::

      docker-into-most-recent-container


How to do a release
===================

- Make sure you are using docker-utils 
i.e.

   ::

      export PATH="~/<LOCATION>/docker-utils/bin:$PATH"


   ::

      build-tag-push-dockerfile.py  --image "newtonsystems/hello" --version 0.1.0 --dockerhub_release --github_release


User Feedback
-------------

Any feedback or comments  would be greatly appreciated: <james.tarball@newtonsystems.co.uk>


Issues
------

If you have any problems with or questions about this image, please contact us through a [GitHub issue](https://github.com/newtonsystems/hello/issues).

You can also reach me by email. I would be happy to help  <james.tarball@newtonsystems.co.uk>

TODO
====
- add command line support via python package cant remement in client.py
- Deploy via wheelhouse and setup.py !!
- docs that work and take stuff from the ptyhon code -> swagger maybe
- protos to docs??
- write a pylint specifically for protobuf
- need confif node name etc how to get it update environement variables on the fly
- TRY external database thingy one last time
- finish service basic
- then cookiecutter the shit out of it
- environment variables
- stability issues
- minor issues 
- relability 
- tornado?
- exception handling??
- Fix linker-viz and zipkin + add namerd
- create a command to create kubneretts yml from docker - like demo-deployment.uaml
- ActiveDeadlineSeconds?? to deploy to environments in cloud
   retstar policy never
- Find a way to hot-reload for docker-machine envs
# sudo ifconfig lo0 alias 192.168.99.101
# sudo ifconfig lo0 -alias 173.20.18.22
#https://serverfault.com/questions/102416/iptables-equivalent-for-mac-os-x