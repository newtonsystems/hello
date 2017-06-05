# hello

[![](https://images.microbadger.com/badges/image/newtonsystems/hello.svg)](https://microbadger.com/images/newtonsystems/hello "Get your own image badge on microbadger.com")

[![](https://images.microbadger.com/badges/version/newtonsystems/hello.svg)](https://microbadger.com/images/newtonsystems/hello "Get your own version badge on microbadger.com")

Available from docker hub as [newtonsystems/tools/hello](https://hub.docker.com/r/newtonsystems/hello/)


#### Supported tags and respective `Dockerfile` links

-    [`v0.1.0`, `latest` (/Dockerfile*)](https://github.com/newtonsystems/docker-python-grpc-service-base/blob/master/Dockerfile)


# A gRPC python microservice

- gRPC python server
- hot-reloading via inotify
- Deployment to minikube


## How to Build the Docker Image
- We have a fairly thorough Makefile to build and run this app a number of different ways. Please see "How to develop this app"




- Run this basic Makefile command to build the Docker image:

    .. code:: python

    import this


.. code:: python
	make build


Essentially the Docker build does the following:
    - copies app/ and setup.py
    - copies any cached wheel files 
    - run pip install against requirements file
    - run a bash script (docker-entrypoint.sh) based on ENV_TYPE

### Other useful build commands

- Run docker build for a different environment e.g. test
```bash
	docker build -t <TAG_NAME> --build-arg APP_ENV=test .
```

- Run a debug Dockerfile (for debugging a container - useful packages installed e.g. iPython, bash-completion etc.)
`NOTE: only run this if you know what you are doing`
```bash
	make build-dev
```

- Run a docker build against the docker-machine / minikube environment
```bash
	make build-dm
```


## How to use this Base Docker Image
- You should use this in your own Dockerfile. Add the following to the top of your Dockerfile:

```
	FROM newtonsystems/docker-python-grpc-service-base:<VERSION>

```


## How to do a release
- Make sure you are using docker-utils 
i.e.

```bash
export PATH="~/<LOCATION>/docker-utils/bin:$PATH"
```

```
build-tag-push-dockerfile.py  --image "newtonsystems/docker-python-grpc-service-base" --version 0.1.0 --dockerhub_release --github_release
```


## User Feedback

Any feedback or comments  would be greatly appreciated: <james.tarball@newtonsystems.co.uk>


### Issues

If you have any problems with or questions about this image, please contact us through a [GitHub issue](https://github.com/newtonsystems/docker-python-grpc-service-base/issues).

You can also reach me by email. I would be happy to help  <james.tarball@newtonsystems.co.uk>


















# docker-pyramid
A dockerized pyramid web server

Find the documentation: https://javaab.github.io/wiki


uses cookiecutter https://github.com/Pylons/pyramid-cookiecutter-starter


maybe should use https://github.com/Pylons/pyramid-cookiecutter-alchemy for the future maybe?


MIGHT NEED A USER MANAGER - ADD / CREATE ETC


TODO
- sort logging
- sort documentation


# port is already allcoated for postgres
pg_ctl -D /usr/local/var/postgres stop -s -m fast


---------------------------------------------------

deploy_sphinx_docs.sh hello docs/build/html/

------------------------------------------------------

- Sort out pshell utility

------------------------------------------------------------------------------




- NEED TO DEFAULT PORT EXPOSE DOCKERFILE, MAKEFILE LOCAL-RUN, ETC, KUBERNETES (NO STATIC 50000)








TODO:
- research prometheus and grafana to set up some useful alerting / graphing when in local development








USAGES
--------


DEBUG MODE
-----------
We have a useful mode for debugging docker containers. This is especially useful if you need to ssh into the container.

- This mode uses `Dockerfile.dev`
- Dockerfile.dev calls debug.txt from config/requirements which will include useful debugging python packages

```sh
make build-dev
make run


If you have docker-utils in your path you can then ssh into the most recent container 
```
docker-into-most-recent-container
```






























new repo
----------
- need to create a repo in dokcer hub
- need to create collabraotr
- need to pull i think first
- then can login and push 









TODO
-----
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

- auto documenting python and grpc 





# - Write commands for docker machine then disable
# - Disable mount for kubernetes
# - comment them out in k8s with a note 













