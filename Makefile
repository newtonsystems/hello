#
# Makefile
#
# Created originally by cookiecutter: version X
#

REPO=hello
PROJECT_NAME=hello

TIMESTAMP=tmp-$(shell date +%s )

CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`

CURRENT_RELEASE_VERSION=0.1.0

LINKERD_SERVICE_PORT=4141

MAC_IP_ADDR=$(ifconfig | grep -A 1 'en0' | tail -1 | cut -d ' ' -f 2 | cut -d ' ' -f 1)
INCOMING_DEV_WORKFLOW_2_ADDR=$(MAC_IP_ADDR)
INCOMING_DEV_WORKFLOW_2_PORT=50000


#
# Colorised Messages
#

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

# Example call
# $(call error_message,  "This is an example error message");


#
# Help for Makefile
#
# Powered by https://gist.github.com/prwhite/8168133
# (Yes duplication here from other message colours .. oh well)
GREEN  := $(shell tput -Txterm setaf 2)
BLUE   := $(shell tput -Txterm setaf 4)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

# Add help text after each target name starting with '\#\#'
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


#
# Basic Prerequisite tests
#
FORCE_IGNORE_PREQ_TEST=false

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


#
# Other
#
.PHONY: help help-show-normal-usage help-how-to

help:                        ##@other Show this help.
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

help-show-normal-usage:      ##@other Shows normal usage case for development (what commands to run)
	@echo "${GREEN}The normal usage is the following for working locally:${RESET}"
	@echo "\tIf you want to run the services locally there are three ways:"
	@echo "\t\t1. Develop & Deploy to minikube"
	@echo "\t\t2. Run docker container locally (using minikube docker environment) + other services in minikube"
	@echo "\t\t3. Run docker container locally + nghttpx + other services in minikube (Recommended)"
	@echo ""
	@echo ""
	@echo "1. Develop & Deploy to minikube"
	@echo "${YELLOW}NOTE: Current docker-machine doesn't support inotify - therefore no hot-reloading, doh!${RESET}"
	@echo ""
	@echo "A normal command workflow may be:"
	@echo "\t${GREEN}make infra-create${RESET}"
	@echo "\t${GREEN}make kube-create${RESET}"
	@echo "\t## Make some dev changes ##"
	@echo "\t${GREEN}make kube-update${RESET}"
	@echo ""
	@echo ""
	@echo "2. Run docker container locally (using minikube docker environment) + other services in minikube"
	@echo ""
	@echo "\t${GREEN}make infra-create${RESET}"
	@echo "\t${GREEN}make run-dm${RESET}"
	@echo "\t## (You must use incoming-dev-workflow-1 to connect external to services) ##"
	@echo "\t## ctrl+c (stop running container) then make some dev changes ##"
	@echo "\t## Maybe a make build-dm ##"
	@echo "\t${GREEN}make run-dm${RESET}"
	@echo ""
	@echo ""
	@echo "3. Run docker container locally + nghttpx + other services in minikube (Recommended)"
	@echo "${YELLOW}NOTE: We must use a special router in linkerd to statically router to a nghttpx reverse proxy (which points to a local running docker container)${RESET}"
	@echo ""
	@echo "\t${GREEN}make infra-create${RESET}"
	@echo "\t${GREEN}make nghttpx${RESET}"
	@echo "\t${GREEN}make run${RESET}"
	@echo "\t## (You must use incoming-dev-workflow-2 to connect external to services) ##"
	@echo "\t## ctrl+c (stop running container) then make some dev changes ##"
	@echo "\t## Maybe a make build ##"
	@echo "\t${GREEN}make run${RESET}"
	@echo ""
	@echo ""

help-how-to:                 ##@other Shows some useful answers to frequent questions
	@echo "$(GREEN)Questions & Answers - How to guide$(RESET)"
	@echo ""
	@echo "$(GREEN)How to add a local python package:$(RESET)"
	@echo "\tYou can add a local python package easily by adding a volume to DOCKER_RUN_COMMAND / DOCKER_RUN_LOCAL_COMMAND"
	@echo "\tObviously make sure it is in the requirements - which it should be already"
	@echo ""
	@echo "$(GREEN)How to ignore the Prerequisites for running this makefile:$(RESET)"
	@echo "\tYou can ignore the Prerequisites by setting FORCE_IGNORE_PREQ_TEST: make <command> FORCE_IGNORE_PREQ_TEST=true"
	@echo ""

#
# Cleanup
#
.PHONY: kube-clean

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
.PHONY: infra-recreate infra-create infra-delete

ADMIN_PORT=`kubectl get svc linkerd -o jsonpath='{.spec.ports[?(@.name=="admin")].nodePort}'`
PING_ADMIN=http://`minikube ip`:$(ADMIN_PORT)/admin/ping
LINKERVIZ_PORT=`kubectl get svc linkerd-viz -o jsonpath='{.spec.ports[?(@.name=="grafana")].nodePort}'`


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
.PHONY: infra-ui infra-linkerd-ping infra-linkerd-logs

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

infra-linkerd-logs:     ##@infra-linkerd-logs Tails linkerd logs
	@echo "$(INFO) Attaching to service $(BLUE)$(LINKERD_POD_NAME)$(RESET) logs"
	kubectl logs -f --tail=50 $(LINKERD_POD_NAME) linkerd


#
# Build Service Locally + Deploy as a pod/service in minikube
#
.PHONY: kube-recreate kube-create kube-delete kube-update kube-mount

POD_NAME=`kubectl get pods -o wide | grep $(PROJECT_NAME) | grep Running | cut -d ' ' -f1`
LINKERD_POD_NAME=`kubectl get pods -o go-template='{{range .items}}{{if eq .status.phase "Running"}}{{.metadata.name}}{{"\n"}}{{end}}{{end}}' | grep linkerd | grep -v linkerd-viz`
POD_PORT=`kubectl get svc $(PROJECT_NAME) -o jsonpath='{.spec.ports[?(@)].nodePort}'`


kube-update:                                         ##@kube Updates service in minikube
	@echo "$(INFO) Deploying $(REPO):$(TIMESTAMP) by replacing image in kubernetes deployment config"
	@eval $$(minikube docker-env); docker image build -t $(REPO):$(TIMESTAMP) -f Dockerfile .
	kubectl set image -f k8s/deploy/deployment.yaml $(PROJECT_NAME)=$(REPO):$(TIMESTAMP)

kube-mount:                                          ##@kube Creates mounts for minikube
	@echo "$(INFO) Setting up kubernetes mounts at $(BLUE).minikube-mounts/$(PROJECT_NAME)$(RESET)"
	@mkdir -p .minikube-mounts/$(PROJECT_NAME)
	@echo "$(WARN) Remember to add to k8s/deploy/deployment.yaml as well!"
	@-ln -s \
		${PWD}/app \
		${PWD}/../libutils/libutils \
	.minikube-mounts/$(PROJECT_NAME)
	@echo "$(INFO) $(BLUE)Creating the following symlinks:$(RESET)"
	@ls -ltra .minikube-mounts/$(PROJECT_NAME) | grep '\->'

kube-create: kube-mount build                  ##@kube Create service and deploy to minikube
	@echo "$(INFO) Building docker image: $(BLUE)hello:local$(RESET) and deploying to minikube."
	kubectl create -f k8s/deploy/
	
	@echo "$(INFO) Wait for service to be ready"
	./wait-for-it.sh -h `minikube ip` -p $(POD_PORT) -t 10
	
	@echo "$(INFO) Attaching to service logs"
	@make kube-logs

kube-delete:                                         ##@kube Delete service from minikube cluster
	@echo "$(INFO) Deleting Service Components from minikube"
	kubectl delete -f k8s/deploy/
	@rm -rf .minikube-mounts/$(PROJECT_NAME)

kube-recreate: kube-delete kube-create   ##@kube Recreate service in minikube
	@echo "$(INFO) Recreating Service Components in minikube"


#
# Kube local helper commands (great for debugging / development)
#
.PHONY: kube-logs kube-env kube-attach kube-six-hour-logs

kube-logs:                   ##@kube-debug Tails logs for the container
	@echo "$(INFO) Attaching to pod $(BLUE)$(POD_NAME)$(RESET) logs"
	@kubectl logs -f --tail=50 $(POD_NAME)

kube-env:                    ##@kube-debug Prints environment variables for the container 
	@echo "$(INFO) Printing the environment variables for $(BLUE)$(POD_NAME)$(RESET)"
	@kubectl exec $(POD_NAME) printenv

kube-attach:                 ##@kube-debug Attachs to the container with a shell
	@echo "$(INFO) Attaching a shell to $(BLUE)$(POD_NAME)$(RESET)"
	kubectl exec -it $(POD_NAME) -- /bin/bash

kube-six-hour-logs:          ##@kube-debug Last six hours worth of logs for $(PROJECT_NAME)
	@echo "$(INFO) $(BLUE)$(POD_NAME)$(RESET) logs for the last $(BLUE)six$(RESET) hours"
	@kubectl logs --since=6h $(POD_NAME)


#
# Build Service Locally + Run locally
#
.PHONY: latest run run-dev daemon build build-dev stop clean check lint

# This is the normal run command (if run from an image in production etc)
DOCKER_RUN_COMMAND=docker run \
	-e "L5D_PORT_4141_TCP=$(LINKERD_SERVICE_PORT)" \
	-p 50000:50000 \
	--name $(REPO)_local

# This is local run command with added volume capability
#--net mynet123 --ip 172.20.18.22
DOCKER_RUN_LOCAL_COMMAND=docker run --rm -it  \
	-p 50000:50000 \
	-e "L5D_PORT_4141_TCP=$(LINKERD_SERVICE_PORT)" \
	--name $(REPO)_local \
	-v ${PWD}/app:/usr/local/src/hello/app #\
	#-v ${PWD}../../libutils:/usr/local/src/libutils \
	#-v ${PWD}./wheelhouse:/wheelhouse


run-latest-release:          ##@local Run the current release (When you want to run as service as a black-box)
	@echo "$(INFO) Pulling release docker image for branch: newtonsystems/$(REPO):$(CURRENT_RELEASE_VERSION)"
	@echo "$(BLUE)"
	docker pull newtonsystems/hello:$(CURRENT_RELEASE_VERSION);
	$(DOCKER_RUN_COMMAND) newtonsystems/$(REPO):$(CURRENT_RELEASE_VERSION) app;
	@echo "$(NO_COLOR)"


run-latest:                  ##@local Run the most up-to-date image for your branch from the docker registry or if the image doesnt exist yet you can specify. (When you want to run as service as a black-box)
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

daemon: build                ##@local Builds and run docker container with tag: '$(REPO):local' as a daemon
	@echo "$(INFO) Running docker container with tag: $(REPO):local as a daemon ..."
	$(DOCKER_RUN_COMMAND) -d $(REPO):local app

run-debug: build-debug       ##@local Builds and run docker container with tag: '$(REPO):local' as a one-off based of Dockerfile.dev (Development Debug Only)
	@echo "$(WARN) Running docker container with tag: $(REPO):local (USING Dockerfile.dev) (ONLY DO THIS IF YOU KNOW WHAT YOU ARE DOING)"
	$(DOCKER_RUN_LOCAL_COMMAND) $(REPO):local app

run-dm: build-dm             ##@local Builds and run docker container with tag: '$(REPO):local' as a one-off. ##@local (dev-workflow-1) Runs docker container on same network as minikube making it accessible from kubernetes minikube and other kubernetes services
	@echo "$(INFO) Running docker container with tag: $(REPO):local"
	@echo "$(BLUE)"
	@eval $$(minikube docker-env); $(DOCKER_RUN_LOCAL_COMMAND) $(REPO):local app
	@echo "$(NO_COLOR)"

build:                       ##@local Builds the local Dockerfile 
	@echo "$(INFO) Building the 'dev' Container locally with tag: $(REPO):local"
	@docker image build --build-arg APP_ENV=dev -t $(REPO):local -f Dockerfile .

build-debug:                   ##@local Builds the local Dockerfile.dev (Development Dockerfile (Not run in production)). Useful if you need to debug a container (Installs helpful tools)
	@echo "$(WARN) Building the Container locally with tag: $(REPO):local using Development Dockerfile (Do not run unless you need to and know what you are doing)"
	@docker image build -t $(REPO):local -f Dockerfile.dev .

build-dm:                       ##@local Builds the local Dockerfile for docker-machine environment
	@echo "$(INFO) Building the Container locally with tag: $(REPO):local"
	@eval $$(minikube docker-env); docker image build --build-arg APP_ENV=dev -t $(REPO):local -f Dockerfile .

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

check: build-dev             ##@local-test Run regression tests against the dockerized service (Run before commit/merge i.e. don't break regression)
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

nghttpx:
	nghttpx 
	#--frontend=$(MAC_IP_ADDR),50000

#
# Deploy (in-staging testing)
#

deploy-cloud:                ##@local-deploy Deploy service to cloud environment (for in staging testing)
	@echo "Not implemented yet ... sorry boss"
