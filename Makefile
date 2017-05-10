NAME=app
PACKAGE_NAME=javaab_auth

# #Calls to docker-env
#DEPS=

# #Modules that need installing
# PYTHON_INSTALL=

# export PYTHON_INSTALL

# ifndef GENEITY_ENV
# 	#Calls to docker-env
# 	DEPS=. docker-env -n rabbitmq rabbitmq 5672,15672 &&
# endif

# #Packges with local changes you wish to use
# #Don't forget to update docker-compose.yml as well
# PYTHON_INSTALL=retailreceipts_types retaillog_types barcode

# export PYTHON_INSTALL

# linkerd/namerd ?

# minikube ?




# all: run

# cmd:
# 	bash -c '$(DEPS) docker-compose run --service-ports $(NAME) $(run) app'

# run:
# 	make cmd

# check:
# 	make cmd run="py.test --cov --cov-report=term-missing"

# pshell:
# 	make cmd run="pshell development.ini"

# sniffer:
# 	make cmd_no_deps run=sniffer

# lint:
# 	make cmd run="pylint $(PACKAGE_NAME)"

# flake8:
# 	make cmd run="flake8"

# shell:
# 	docker-compose run $(NAME) /bin/bash



# build:
# 	nuitka --portable --show-progress --show-scons --remove-output --improved --python-flag=no_site app/service.py








# build:
# 	sudo docker build -t sherzberg/curdserver .

# shell:
# 	sudo docker run -i -t sherzberg/curdserver /bin/bash

# daemon:
# 	sudo docker run -p 8000:8000 -v /var/wheelhouse:/var/wheelhouse:rw -d sherzberg/curdserver

# push:
# 	sudo docker push sherzberg/curdserver







# build - should build the binary executable for the dockerfile




# 
#########
# local-linkerd-ping




#
# Current Known Problems
# - Fails to remove docker container upon exit (ctrl+c)
#
#

# clean


# Minikube (Local Kubernetes)
# kube (build + apply)
# kube-recreate
# kube-delete
# kube-create
# kube-latest
# kube-mount


# Useful commands (for service running in minikube)
######
# kube-env
# kube-logs
# kube-dashboard


NO_COLOR=\033[0m
GREEN=\033[0;32m
RED=\033[31;01m
WARN_COLOR=\033[33;01m
 
OK_STRING=$(OK_COLOR)[OK]$(NO_COLOR)
INFO=$(GREEN)====>>[INFO]$(NO_COLOR)
ERROR=$(RED)====>>[ERROR]$(NO_COLOR)
WARN=$(YELLOW)====>>[WARN]$(NO_COLOR)


define info_message
    @echo "$(ERROR)$(RED)$(1)$(NO_COLOR)";
endef

define warn_message
    echo "$(WARN)$(YELLOW)$(1)$(NO_COLOR)"
endef

define error_message
    echo "$(ERROR)$(RED)$(1)$(NO_COLOR)"
endef



.PHONY: local mount create delete
REPO=hello
PROJECT_NAME=hello
TIMESTAMP=tmp-$(shell date +%s )



PROJECT_DIR=..




# https://github.com/linkerd/linkerd/wiki/Flavors-of-Kubernetes
ADMIN_PORT=`kubectl get svc linkerd -o jsonpath='{.spec.ports[?(@.name=="admin")].nodePort}'`
OUTGOING_PORT=`kubectl get svc linkerd -o jsonpath='{.spec.ports[?(@.name=="outgoing")].nodePort}'`
INCOMING_PORT=`kubectl get svc linkerd -o jsonpath='{.spec.ports[?(@.name=="incoming")].nodePort}'`
LINKERVIZ_PORT=`kubectl get svc linkerd-viz -o jsonpath='{.spec.ports[?(@.name=="grafana")].nodePort}'`



LINKERD_INGRESS_LB=http://`minikube ip`:$(INCOMING_PORT)
LINKERD_EGRESS_LB=http://`minikube ip`:$(OUTGOING_PORT)

MINIKUBE_IP=`minikube ip`
PING_ADMIN=http://`minikube ip`:$(ADMIN_PORT)/admin/ping



# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# Powered by https://gist.github.com/prwhite/8168133
#COLORS
GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# A category can be added with @category
HELP_FUN = \
    %help; \
    while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
    print "usage: make [target]\n\n"; \
    for (sort keys %help) { \
    print "${WHITE}$$_:${RESET}\n"; \
    for (@{$$help{$$_}}) { \
    $$sep = " " x (32 - length $$_->[0]); \
    print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
    }; \
    print "\n"; }

help: ##@other Show this help.
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

describe-local-category: ##@other Describes the 'local' category and what it is used for
	@echo "sahkjdhka"

help-show-normal-usage:      ##@other Shows normal usage case for development (what commands to run)
	@echo "dsfk"

help-quick-start:
	@echo "dsjfk"


help-how-to:
	@echo "sdfdsf"
	@echo "How to add a local python package"
	@echo "How to run the latest image from the branch"
	@echo "How to run all services except this one via minikube"


kube-clean:                       ##@cleanup Clean Up Environment. Deletes all kubernetes components
	kubectl delete deployment --all
	kubectl delete daemonset --all
	kubectl delete replicationcontroller --all
	kubectl delete services --all
	kubectl delete pods --all
	kubectl delete configmap --all

#
# Infrastructure
#

infra-recreate:              ##@infrastructure Recreate all critical infrastructure components in minikube to run with your service
	@echo "$(INFO) Re-creating Infrastructure Components"
	make infra-delete
	make infra-create

infra-create:                ##@infrastructure Creates all critical infrastructure components (via minikube/k8s)
	@echo "$(INFO) Creating Infrastructure Components"
	kubectl apply -f ../devops/k8s/deploy/local/

infra-delete:                ##@infrastructure Deletes all critical instructure components (via minikube/k8s)
	@echo "$(INFO) Deleting Infrastructure Components"
	kubectl delete -f ../devops/k8s/deploy/local/

#
# Infrastructure helper commands
#

infra-linkerd-ping:          ##@infrastructure-helper-commands Pings linkerd's admin. A useful way to see if linkerd is up and running.
	@echo "$(INFO) Pinging Linkerd Admin Interface. You should receive a message 'pong'"
	@if [ '$(shell curl $(PING_ADMIN))' != 'pong' ]; then \
		$(call error_message,  "Failed to receive a "'pong'" response. It looks like linkerd is not running..."); \
		exit 1; \
	fi

infra-ui:                    ##@infrastructure-helper-commands Open all infrastructure's user interfaces. Perfect for monitoring, debugging and tracing microservices. (linkerd admin, linker-viz, zipkin, prometheus)
	@echo ""



#
# Build Service Locally
#

DOCKER_RUN_COMMAND=docker run --rm -t \
	-p 50000:50000 \
	-v ${PWD}/app:/app \
	-v ${PWD}../../libutils:/usr/local/src/libutils \
	-v ${PWD}./wheelhouse:/wheelhouse


build:                       ##@local Builds the local Dockerfile 
	@echo "$(INFO) Building the Container locally with tag: $(REPO):local"
	@docker image build -t $(REPO):local -f Dockerfile .


build-dev:                   ##@local Builds the local Dockerfile.dev (Development Dockerfile (Not run in production)). Useful if you need to debug a container (Installs helpful tools)
	@echo "$(WARN) Building the Container locally with tag: $(REPO):local using Development Dockerfile (Do not run unless you need to and know what you are doing)"
	@docker image build -t $(REPO):local -f Dockerfile.dev .


run: build                   ##@local Builds and run docker container with tag: '$(REPO):local' as a one-off
	@echo "$(INFO) Running docker container with tag: $(REPO):local"
	$(DOCKER_RUN_COMMAND) $(REPO):local app


run-dev: build-dev           ##@local Builds and run docker container with tag: '$(REPO):local' as a one-off based of Dockerfile.dev (Development Debug Only)
	@echo "$(WARN) Running docker container with tag: $(REPO):local (USING Dockerfile.dev)"
	$(DOCKER_RUN_COMMAND) $(REPO):local app


run-latest: 
	@echo "dsf"
	docker pull
	docker run 


daemon:
	@echo "$(INFO) Running docker container with tag: $(REPO):local as a daemon ..."
	$(DOCKER_RUN_COMMAND) -d $(REPO):local app


latest:
	@echo "fdsf"
	PULL_IMAGE=master
	docker pull newtonsystems/$(REPO):$(PULL_IMAGE)


clean:                ##@local Removes all docker processes, containers and images for '$(REPO):local'
	@echo "$(INFO) Cleaning all docker processes, containers and images for $(REPO):local"
	@if [ -n "`docker ps -q -f ancestor=$(REPO):local`" ]; then \
		echo "$(INFO) Stopping docker processes with tag: 'hello:local'"; \
		docker stop `docker ps -q -f ancestor=$(REPO):local`; \
	else \
		$(call warn_message,  "No docker processes with image name "'"$(REPO):local"'" found to stop."); \
	fi

	@if [ -n "`docker ps -q -f ancestor=$(REPO):local`" ]; then \
		echo "$(INFO) Removing docker containers with tag: 'hello:local'"; \
		docker rm `docker ps -q -f ancestor=$(REPO):local`; \
	else \
		$(call warn_message,  "No docker container with image name "'"$(REPO):local"'" found to remove."); \
	fi

	@if [ -n "`docker images hello:local -q`" ]; then \
		echo "$(INFO) Removing docker images with tag: 'hello:local'"; \
		docker rmi `docker images hello:local -q`; \
	else \
		$(call warn_message,  "No docker container with image name "'"$(REPO):local"'" found to remove."); \
	fi






shell:
	@echo ""


check:                 ##@local Run regression tests against the dockerized service (Run before commit/merge - don't break regression)
	@echo "$(INFO) Running some tests inside the container"








# (connect to minikube as an external service)
# local  (build + run)
# local-build - docker build
# local-run   - docker run 
# local-daemon
# local-lint
# local-run-latest (latest for branch if exists or can set with a value)
# local-check        (run tests in docker)
# local-shell

















# ok if not started 
# need external links
# we not started linkerd and namerd (from a docker-compose)








# ONLY SUPPORT ONE REPLICATION (ONE INSTANCE!!! )
# AT THE MOMENT 





# local-infra:
# 	#TODO: If already created THIS WILL EXPLODE
# 	kubectl create namespace infra



local-ui:
	minikube service l5d --url | tail -n1 | xargs open # on OS X
	@echo "$(INFO) Opening zipkin (distributed tracing)"
	minikube service zipkin
	#@echo "$(INFO) Opening minikube dashboard (Kubernetes dashboard)"
	#@minikube dashboard
	#@echo "$(INFO) Opening Heapster - Resource Usage Analysis and Monitoring"
	#@open `minikube service monitoring-grafana --namespace=kube-system  --url`


local-create-infra:
	kubectl create -f ../devops/deploy/local/

local-apply-infra:
	kubectl apply -f ../devops/deploy/local/


local-infra-create-linkerd:
	kubectl create -f ../devops/k8s/deploy/local/linkerd.yml

local-infra-apply-linkerd:
	kubectl apply -f ../devops/k8s/deploy/local/linkerd.yml

local-get-pods:
	kubectl get pods -o wide


















local-clean:
	kubectl delete deployment --all
	kubectl delete daemonset --all
	kubectl delete replicationcontroller --all
	kubectl delete services --all
	kubectl delete pods --all
	kubectl delete configmap --all


local-infra-dashboard:
	@echo "$(INFO) Opening Dashboard for Linkerd Admin"
	@open http://`minikube ip`:$(ADMIN_PORT)
	@echo "$(INFO) Opening Dashboard for Linkerd Viz Admin"
	@open http://`minikube ip`:$(LINKERVIZ_PORT)





local-hello:
	@echo "$(INFO) Hello World test"
	@http_proxy=$(LINKERD_INGRESS_LB) curl -s http://hello


local-world:
	@echo "$(INFO) Hello World test"
	@http_proxy=$(LINKERD_INGRESS_LB) curl -s http://world



local:
	@eval $$(minikube docker-env) ;\
	docker image build -t $(REPO):$(TIMESTAMP) -f Dockerfile .
	@echo "$(INFO) Deploying $(REPO):$(TIMESTAMP)"
	kubectl set image -f k8s/deploy/deployment.yaml hello=$(REPO):$(TIMESTAMP)


# local-run:
# 	@echo "$(INFO) Running Container with tag: local"
# 	docker run --rm -t \
# 		-p 50000:50000 \
# 		-v ${PWD}/app:/app \
# 		-v ${PWD}../../libutils:/usr/local/src/libutils \
# 		-v ${PWD}./wheelhouse:/wheelhouse \
# 		local app







# TODO: Do something better using regex or sed/awk Or develop newtonctl cli
create:
	@if [ '$(shell minikube status | grep minikubeVM)' != 'minikubeVM: Running' ]; then \
		echo "$(ERROR) Minikube is not running. Please run 'minikube start'."; \
		exit 1; \
	fi
	@echo "$(INFO) Creating Dockerfile and deploying to minikube."
	eval $$(minikube docker-env) ;\
	docker image build -t $(REPO):create -f Dockerfile .
	kubectl create -f k8s/deploy/

recreate:
	make delete
	make create

recreate-linkerd:
	make delete-linkerd
	make create-linkerd


delete-linkerd:
	kubectl delete -f ../devops/k8s/deploy/local/linkerd.yml

create-linkerd:
	kubectl apply -f ../devops/k8s/deploy/local/linkerd.yml


delete:
	kubectl delete -f k8s/deploy/

local-dashboard:
	@echo "$(INFO) Opening minikube dashboard (Kubernetes dashboard)"
	@minikube dashboard
	@echo "$(INFO) Opening Heapster - Resource Usage Analysis and Monitoring"
	@open `minikube service monitoring-grafana --namespace=kube-system  --url`

local-curl:
	curl $(minikube service hello --url)

local-logs:
	kubectl logs -f --tail=50 `kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' | grep hello`
	echo "TODO"

local-logs-last-hours:
	echo "TODO"

local-attach:
	echo "TODO"




local-linkerd-logs:
	kubectl logs -f --tail=50 `kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' | grep l5d` l5d








local-check:
# 	make cmd run="py.test --cov --cov-report=term-missing"
	kubectl exec hello-1887293505-8s7v9 -- printenv

local-env:
	@echo "$(INFO) Printing the environment variables for the container"
	kubectl exec hello-1887293505-8s7v9 printenv


mount:
	@echo "Setting up mount as symlink in ~/.minikube-mounts folder"
	$(shell sudo mkdir -p ~/.minikube-mounts/hello)
	#$(shell sudo mkdir -p ~/.minikube-mounts/hello/libutils)
	$(shell sudo ln -s ${PWD}/app ~/.minikube-mounts/hello/app)
	$(shell sudo ln -s ${PWD}/libutils ~/.minikube-mounts/hello/libutils)
	@echo $(shell ls ~/.minikube-mounts/hello)



# kubectl logs my-pod                                 # dump pod logs (stdout)
# $ kubectl logs my-pod -c my-container                 # dump pod container logs (stdout, multi-container case)
# $ kubectl logs -f my-pod                              # stream pod logs (stdout)
# $ kubectl logs -f my-pod -c my-container              # stream pod container logs (stdout, multi-container case)
# $ kubectl run -i --tty busybox --image=busybox -- sh  # Run pod as interactive shell
# $ kubectl attach my-pod -i                            # Attach to Running Container
# $ kubectl port-forward my-pod 5000:6000               # Forward port 6000 of Pod to your to 5000 on your local machine
# $ kubectl exec my-pod -- ls /                         # Run command in existing pod (1 container case)
# $ kubectl exec my-pod -c my-container -- ls /         # Run command in existing pod (multi-container case)
# $ kubectl top pod POD_NAME --containers               # Show metrics for a given pod and its containers













