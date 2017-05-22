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




