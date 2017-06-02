#
# Makefile version 
# created by cookiecutter blah
#


NAME=app
PACKAGE_NAME=javaab_auth

SERVICE_PORT=4141

CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`




MAC_IP_ADDR=$(ifconfig | grep -A 1 'en0' | tail -1 | cut -d ' ' -f 2 | cut -d ' ' -f 1)
INCOMING_DEV_WORKFLOW_2_ADDR=$(MAC_IP_ADDR)
INCOMING_DEV_WORKFLOW_2_PORT=50000


# #Calls to docker-env
#DEPS=

# #Modules that need installing
# PYTHON_INSTALL=

# export PYTHON_INSTALL
#kubectl get pods - -o go-template='{{range .items}}{{if eq .status.phase "Running"}}{{.metadata.name}}{{"\n"}}{{end}}{{end}}' | grep $(PROJECT_NAME)
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

	# kubectl get pods -o go-template='{{range .items}}{{if eq .status.phase "Running"}}{{.metadata.name}}{{"\n"}}{{end}}{{end}}' | grep $(PROJECT_NAME)
	# @echo "2222222"
	# JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}' \
 # && kubectl get pods -o jsonpath=$JSONPATH | grep "Ready=True"


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



# sudo ifconfig lo0 alias 192.168.99.101
# sudo ifconfig lo0 -alias 173.20.18.22
#
#https://serverfault.com/questions/102416/iptables-equivalent-for-mac-os-x


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

# set username and password
UNAME="jtarball"
UPASS="mirage27"

ifdef docker_tag_exists
    TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d '{"username": "'${UNAME}'", "password": "'${UPASS}'"}' https://hub.docker.com/v2/users/login/ | jq -r .token)
    EXISTS=$(curl -s -H "Authorization: JWT ${TOKEN}" https://hub.docker.com/v2/repositories/$1/tags/?page_size=10000 | jq -r "[.results | .[] | .name == \"$2\"] | any")
    test $EXISTS = true
endif

# $(call error_message,  "Failed to receive a "'pong'" response. It looks like linkerd is not running..."); \



.PHONY: local mount create delete
REPO=hello
PROJECT_NAME=hello
TIMESTAMP=tmp-$(shell date +%s )



PROJECT_DIR=..


# NEED TO CHANGE INFRA TO USE PROJECT_DIR!!!!!

# https://github.com/linkerd/linkerd/wiki/Flavors-of-Kubernetes
ADMIN_PORT=`kubectl get svc linkerd -o jsonpath='{.spec.ports[?(@.name=="admin")].nodePort}'`
OUTGOING_PORT=`kubectl get svc linkerd -o jsonpath='{.spec.ports[?(@.name=="outgoing")].nodePort}'`
INCOMING_PORT=`kubectl get svc linkerd -o jsonpath='{.spec.ports[?(@.name=="incoming")].nodePort}'`
LINKERVIZ_PORT=`kubectl get svc linkerd-viz -o jsonpath='{.spec.ports[?(@.name=="grafana")].nodePort}'`






LINKERD_INGRESS_LB=http://`minikube ip`:$(INCOMING_PORT)
LINKERD_EGRESS_LB=http://`minikube ip`:$(OUTGOING_PORT)
LINKERD_ADMIN=http://`minikube ip`:$(ADMIN_PORT)

MINIKUBE_IP=`minikube ip`
PING_ADMIN=http://`minikube ip`:$(ADMIN_PORT)/admin/ping



# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# Powered by https://gist.github.com/prwhite/8168133
#COLORS
GREEN  := $(shell tput -Txterm setaf 2)
BLUE   := $(shell tput -Txterm setaf 4)
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

FORCE_IGNORE_PREQ_TEST=false

#
# Basic Prerequisite tests
#
ifeq ($(FORCE_IGNORE_PREQ_TEST), false)

    # Basic Prerequisite test: Is docker running?
    ifneq ('$(shell docker --version)', 'Docker version 17.03.1-ce, build c6d412e') 
        $(error Docker is not running. Please run start docker.)
    endif 

    # Basic Prerequisite test: Is Minikube running?
    ifneq ('$(shell minikube status | grep minikubeVM)', 'minikubeVM: Running')
        $(error Minikube is not running. Please run 'minikube start'.)
    endif

    ifneq ('$(shell nghttpx -v)', 'nghttpx nghttp2/1.23.1')
        $(error nghttpx is not current installed or is a different version.)
    endif

endif


help: ##@other Show this help.
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

describe-local-category: ##@other Describes the 'local' category and what it is used for
	@echo "sahkjdhka"

help-show-normal-usage:      ##@other Shows normal usage case for development (what commands to run)
	@echo "${GREEN}The normal usage is the following for working locally:${RESET}"
	@echo "${YELLOW}\tPREREQUISTIC: Make sure minikube is running 'minikube start'${RESET}"
	@echo "\t1) If you want to run the services locally:"
	@echo "\tYou need to create the infrastructure services (linkerd etc)"
	@echo "${YELLOW}\t\tinfra-create${RESET}"
	@echo "${YELLOW}\t\tinfra-create${RESET}"


help-quick-start:
	@echo "dsjfk"


help-how-to:
	@echo "sdfdsf"
	@echo "How to add a local python package"
	@echo "How to run the latest image from the branch"
	@echo "How to run all services except this one via minikube"


help-common-troubleshooting:
	@echo "${RED} Heapster UI not available:${RESET} Waiting, endpoint for service is not ready yet..."
	@echo "1.) Check heapster service is running: ${GREEN}kubectl get services --namespace=kube-system${RESET}"
	@echo "2.) Restart heapster service: ${GREEN}kubectl delete service --namespace=kube-system heapster${RESET}"
	@echo "3.) Disable and then enable heapster addon: ${GREEN}minikube addons disable heapster; minikube addons enable heapster;${RESET}"


proj-clean:
	echo "jdks"
	rm -rf .minikube-mounts



kube-clean:                       ##@cleanup Cleans Up Kubernetes Environment. Deletes all kubernetes components (services, pods, config, deployments ... etc)
	kubectl delete deployment --all
	kubectl delete daemonset --all
	kubectl delete replicationcontroller --all
	kubectl delete services --all
	kubectl delete pods --all
	kubectl delete configmap --all
	-@eval $$(minikube docker-env); docker-rm-unnamed-images;


#
# Infrastructure
#

infra-recreate:              ##@infrastructure Recreates all critical infrastructure components to run with your service (via minikube/k8s)
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
.PHONY: infra-ui infra-linkerd-ping

infra-ui:                    ##@infrastructure-helper-commands Open all infrastructure's UIs. Perfect for monitoring, debugging and tracing microservices.
	@echo "$(INFO) Opening minikube dashboard (Kubernetes dashboard)"
	@minikube dashboard
	@echo "$(INFO) Opening linkerd 's admin page ..."
	@minikube service linkerd --url | tail -n1 | xargs open
	@echo "$(INFO) Opening linkerd viz ..."
	@open http://`minikube ip`:$(LINKERVIZ_PORT)
	@echo "$(INFO) Opening zipkin (distributed tracing)"
	@minikube service zipkin
	@echo "$(WARN) Not going to open minikube addon heapster. Heapster not currently working with minikube 0.19 (works with 0.18) (21/5/17)"
# @echo "$(INFO) Opening Heapster - Resource Usage Analysis and Monitoring"
# @open `minikube service monitoring-grafana --namespace=kube-system  --url`

infra-linkerd-ping:          ##@infrastructure-helper-commands Pings linkerd's admin. A useful way to see if linkerd is up and running.
	@printf "$(GREEN) Pinging Linkerd Admin Interface ... $(RESET)"
	@if [ '$(shell curl $(PING_ADMIN))' != 'pong' ]; then \
		echo "$(RED)Failed to receive a "'pong'" response. It looks like linkerd is not running...$(RESET)"; \
		exit 1; \
	else \
		echo "$(GREEN)Successful ping.$(RESET)"; \
	fi


#
# Build Service Locally + Deploy as a pod/service in minikube
#
.PHONY: kube-local-recreate kube-local-create kube-local-delete kube-local-update kube-local-mount

POD_NAME=`kubectl get pods -o wide | grep $(PROJECT_NAME) | grep Running | cut -d ' ' -f1`
LINKERD_POD_NAME=`kubectl get pods -o go-template='{{range .items}}{{if eq .status.phase "Running"}}{{.metadata.name}}{{"\n"}}{{end}}{{end}}' | grep linkerd | grep -v linkerd-viz`
POD_PORT=`kubectl get svc $(PROJECT_NAME) -o jsonpath='{.spec.ports[?(@)].nodePort}'`


kube-local-update:                                         ##@kube-local Updates service in minikube
	@echo "$(INFO) Deploying $(REPO):$(TIMESTAMP) by replacing image in kubernetes deployment config"
	@eval $$(minikube docker-env); docker image build -t $(REPO):$(TIMESTAMP) -f Dockerfile .
	kubectl set image -f k8s/deploy/deployment.yaml $(PROJECT_NAME)=$(REPO):$(TIMESTAMP)

kube-local-mount:                                          ##@kube-local Creates mounts for minikube
	@echo "$(INFO) Setting up kubernetes mounts at $(BLUE).minikube-mounts/$(PROJECT_NAME)$(RESET)"
	@mkdir -p .minikube-mounts/$(PROJECT_NAME)
	@echo "$(WARN) Remember to add to k8s/deploy/deployment.yaml as well!"
	@-ln -s \
		${PWD}/app \
		${PWD}/../libutils/libutils \
	.minikube-mounts/$(PROJECT_NAME)
	@echo "$(INFO) $(BLUE)Creating the following symlinks:$(RESET)"
	@ls -ltra .minikube-mounts/$(PROJECT_NAME) | grep '\->'

kube-local-create: kube-local-mount build                  ##@kube-local Create service and deploy to minikube
	@echo "$(INFO) Building docker image: $(BLUE)hello:local$(RESET) and deploying to minikube."
	kubectl create -f k8s/deploy/
	
	@echo "$(INFO) Wait for service to be ready"
	./wait-for-it.sh -h `minikube ip` -p $(POD_PORT) -t 10
	
	@echo "$(INFO) Attaching to service logs"
	@make kube-local-logs

kube-local-delete:                                         ##@kube-local Delete service from minikube cluster
	@echo "$(INFO) Deleting Service Components from minikube"
	kubectl delete -f k8s/deploy/
	@rm -rf .minikube-mounts/$(PROJECT_NAME)

kube-local-recreate: kube-local-delete kube-local-create   ##@kube-local Recreate service in minikube
	@echo "$(INFO) Recreating Service Components in minikube"


#
# Kube local helper commands (great for debugging / development)
#
.PHONY: kube-local-linkerd-logs kube-local-logs kube-local-env kube-local-attach kube-local-six-hour-logs

kube-local-linkerd-logs:     ##@kube-local-debug Tails linkerd logs
	@echo "$(INFO) Attaching to service $(BLUE)$(LINKERD_POD_NAME)$(RESET) logs"
	kubectl logs -f --tail=50 $(LINKERD_POD_NAME) linkerd

kube-local-logs:              ##@kube-local-debug Tails logs for the container
	@echo "$(INFO) Attaching to pod $(BLUE)$(POD_NAME)$(RESET) logs"
	@kubectl logs -f --tail=50 $(POD_NAME)

kube-local-env:              ##@kube-local-debug Prints environment variables for the container 
	@echo "$(INFO) Printing the environment variables for $(BLUE)$(POD_NAME)$(RESET)"
	@kubectl exec $(POD_NAME) printenv

kube-local-attach:           ##@kube-local-debug Attachs to the container with a shell
	@echo "$(INFO) Attaching a shell to $(BLUE)$(POD_NAME)$(RESET)"
	kubectl exec -it $(POD_NAME) -- /bin/bash

kube-local-six-hour-logs:    ##@kube-local-debug Last six hours worth of logs for $(PROJECT_NAME)
	@echo "$(INFO)  $(BLUE)$(POD_NAME)$(RESET) logs for the last $(BLUE)six$(RESET) hours"
	@kubectl logs --since=6h $(POD_NAME)


#
# Build Service Locally + Run locally
#
.PHONY: latest run run-dev daemon build build-dev stop clean check lint

# This is the normal run command (if run from an image in production etc)
DOCKER_RUN_COMMAND=docker run \
	-e "L5D_PORT_4141_TCP=$(SERVICE_PORT)" \
	-p 50000:50000 \
	--name $(REPO)_local

# This is local run command with added volume capability
#--net mynet123 --ip 172.20.18.22
DOCKER_RUN_LOCAL_COMMAND=docker run --rm -it  \
	-p 50000:50000 \
	-e "L5D_PORT_4141_TCP=$(SERVICE_PORT)" \
	--name $(REPO)_local \
	-v ${PWD}/app:/app #\
	#-v ${PWD}../../libutils:/usr/local/src/libutils \
	#-v ${PWD}./wheelhouse:/wheelhouse


latest:                      ##@local Run the most up-to-date image for your branch from the docker registry or if the image doesnt exist yet you can specify. (When you want to run as service as a black-box)
	@echo "$(INFO) Running the most up-to-date image"
	@echo "$(INFO) Pulling latest docker image for branch: newtonsystems/$(REPO):master"
	@docker pull newtonsystems/$(REPO):master; if [ $$? -ne 0 ] ; then \
		echo "$(ERROR) Failed to find image in registry: newtonsystems/$(REPO):master1"; \
		read -r -p "$(GREEN) Specific your own image name or Ctrl+C to exit:$(RESET)   " reply; \
		docker pull newtonsystems/$(REPO):$$reply; \
		$(DOCKER_RUN_COMMAND) newtonsystems/$(REPO):$$reply app; \
	else \
		$(DOCKER_RUN_COMMAND) newtonsystems/$(REPO):master app; \
	fi

## Development Workflow 2 (See above for information or make help-show-normal-usage)
run: build                   ##@local Builds and run docker container with tag: '$(REPO):local' as a one-off. ##@local (dev-workflow-2) Runs docker container on same network as minikube making it accessible from kubernetes minikube and other kubernetes services
	@echo "$(INFO) Running docker container with tag: $(REPO):local"
	@echo "$(BLUE)"
	$(DOCKER_RUN_LOCAL_COMMAND) $(REPO):local app
	@echo "$(NO_COLOR)"

run-dev: build-dev           ##@local Builds and run docker container with tag: '$(REPO):local' as a one-off based of Dockerfile.dev (Development Debug Only)
	@echo "$(WARN) Running docker container with tag: $(REPO):local (USING Dockerfile.dev) (ONLY DO THIS IF YOU KNOW WHAT YOU ARE DOING)"
	$(DOCKER_RUN_LOCAL_COMMAND) $(REPO):local app

daemon: build                ##@local Builds and run docker container with tag: '$(REPO):local' as a daemon
	@echo "$(INFO) Running docker container with tag: $(REPO):local as a daemon ..."
	$(DOCKER_RUN_COMMAND) -d $(REPO):local app

build:                       ##@local Builds the local Dockerfile 
	@echo "$(INFO) Building the Container locally with tag: $(REPO):local"
	@docker image build --build-arg APP_ENV=dev -t $(REPO):local -f Dockerfile .

build-dm:                       ##@local Builds the local Dockerfile for docker-machine environment
	@echo "$(INFO) Building the Container locally with tag: $(REPO):local"
	@eval $$(minikube docker-env); docker image build --build-arg APP_ENV=dev -t $(REPO):local -f Dockerfile .

build-dev:                       ##@local Builds the local Dockerfile 
	@echo "$(INFO) Building the Container locally with tag: $(REPO):local"
	@docker image build -t $(REPO):local -f Dockerfile --build-arg APP_ENV=dev .

build-deb:                   ##@local Builds the local Dockerfile.dev (Development Dockerfile (Not run in production)). Useful if you need to debug a container (Installs helpful tools)
	@echo "$(WARN) Building the Container locally with tag: $(REPO):local using Development Dockerfile (Do not run unless you need to and know what you are doing)"
	@docker image build -t $(REPO):local -f Dockerfile.dev .

stop:                        ##@local Stops all docker containers with tag: '$(REPO):local' and name '$(REPO)_local'
	@if [ -n "`docker ps -a -q -f ancestor=$(REPO):local`" ]; then \
		echo "$(INFO) Stopping all docker processes with tag: 'hello:local'"; \
		docker stop `docker ps -a -q -f ancestor=$(REPO):local`; \
	else \
		$(call warn_message,  "No docker processes with image tag "'"$(REPO):local"'" found to stop."); \
	fi

	@if [ -n "`docker ps -a -q -f name=$(REPO)_local`" ]; then \
		echo "$(INFO) Stopping all docker processes with name: 'hello_local'"; \
		docker stop `docker ps -a -q -f name=$(REPO)_local`; \
	else \
		$(call warn_message,  "No docker processes with name "'"$(REPO)_local"'" found to stop."); \
	fi

shell: build-dev                  ##@local Run bash shell against the dockerized service 
	@echo "$(INFO) Running lint tests against the docker container"
	$(DOCKER_RUN_LOCAL_COMMAND) -it $(REPO):local /bin/bash

remove: stop                 ##@local Stops and remove docker containers with tag: '$(REPO):local' and name '$(REPO)_local'
	@if [ -n "`docker ps -a -q -f ancestor=$(REPO):local`" ]; then \
		echo "$(INFO) Removing docker containers with tag: 'hello:local'"; \
		docker rm `docker ps -a -q -f ancestor=$(REPO):local`; \
	else \
		$(call warn_message,  "No docker container with image tag "'"$(REPO):local"'" found to remove."); \
	fi

	@if [ -n "`docker ps -a -q -f name=$(REPO)_local`" ]; then \
		echo "$(INFO) Removing docker containers with name: 'hello_local'"; \
		docker rm `docker ps -a -q -f name=$(REPO)_local`; \
	else \
		$(call warn_message,  "No docker container with name "'"$(REPO):local"'" found to remove."); \
	fi

clean:                       ##@local Removes all docker processes, containers and images for '$(REPO):local'
	@echo "$(INFO) Cleaning all docker processes, containers and images for $(REPO):local"
	make stop
	make remove

	@if [ -n "`docker images hello:local -q`" ]; then \
		echo "$(INFO) Removing docker images with tag: 'hello:local'"; \
		docker rmi `docker images hello:local -q`; \
	else \
		$(call warn_message,  "No docker container with image name "'"$(REPO):local"'" found to remove."); \
	fi

check: build-dev                      ##@local-test Run regression tests against the dockerized service (Run before commit/merge i.e. don't break regression)
	@echo "$(INFO) Running some tests inside the container"
	$(DOCKER_RUN_LOCAL_COMMAND) $(REPO):local run_tests.sh

lint: build                  ##@local-test Run lint tests against the dockerized service 
	@echo "$(INFO) Running lint tests against the docker container"
	$(DOCKER_RUN_LOCAL_COMMAND) $(REPO):local pylint -r y --output-format=colorized --load-plugins=pylint.extensions.check_docs app


# Example Configuration
#
# frontend=192.168.1.237,50000;;no-tls
# backend=0.0.0.0,50000;/;proto=h2
# private-key-file=/etc/ssl/private/my.ssl.key
# certificate-file=/etc/ssl/private/my.ssl.pem
# workers=1
# http2-proxy=yes
# log-level=INFO

start-nghttpx:
	nghttpx 
	#--frontend=$(MAC_IP_ADDR),50000



##############

deploy-cloud:
	echo "
		frontend=192.168.1.237,50000;;no-tls
		backend=0.0.0.0,50000;/;proto=h2
		private-key-file=/etc/ssl/private/my.ssl.key  
		certificate-file=/etc/ssl/private/my.ssl.pem
		workers=1
		http2-proxy=yes
		log-level=INFO
	"
	echo "specify cloud are you sure -- very importatn"
	echo "afdjkds"



connect-to-kube:
	@echo "$(WARN) Make sure nghttpx is running 'make start-nghttpx'"











local-check:
# 	make cmd run="py.test --cov --cov-report=term-missing"
	kubectl exec hello-1887293505-8s7v9 -- printenv






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













