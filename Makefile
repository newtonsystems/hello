#
# Makefile
#
# Created originally by cookiecutter: version X
#

REPO=hello
PROJECT_NAME=hello
NEWTON_DIR=/Users/danvir/Masterbox/sideprojects/github/newtonsystems/

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
checks     :=$(shell /bin/bash -c "check-setup.sh")
ifeq ($(FORCE_IGNORE_PREQ_TEST), false)

    ifneq ($(shell /bin/bash -c "check-setup.sh"; echo $$?), 0)
        $(error $(checks))
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
# Build Service Locally + Run locally
#
.PHONY: latest run run-dev daemon build build-debug stop clean check lint

# This is the normal run command (if run from an image in production etc)
DOCKER_RUN_COMMAND=docker run \
	-e "L5D_PORT_4141_TCP=$(LINKERD_SERVICE_PORT)" \
	-p 50000:50000 \
	--name $(REPO)_local

# This is local run command with added volume capability
#--net mynet123 --ip 172.20.18.22
DOCKER_RUN_LOCAL_COMMAND=docker run -it  \
	-p 50000:50000 \
	-e "L5D_PORT_4141_TCP=$(LINKERD_SERVICE_PORT)" \
	-v ${PWD}/wheelhouse:/wheelhouse \
	-v ${PWD}/app:/usr/local/src/hello/app
	#--name $(REPO)_local \
	#\
	#-v ${PWD}../../libutils:/usr/local/src/libutils \
	


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



#
# Run locally
#
build:                       ##@local Builds the local Dockerfile
	mkdir -p wheelhouse 
	@echo "$(INFO) Building the 'dev' Container locally with tag: $(REPO):local"
	docker image build --build-arg APP_ENV=prod --build-arg PYPI_INDEX=$(CURRENT_BRANCH) -t $(REPO):local -f Dockerfile .
	@echo ""

run: build                   ##@local Builds and run docker container with tag: '$(REPO):local' as a one-off. ##@local (dev-workflow-2) Runs docker container on same network as minikube making it accessible from kubernetes minikube and other kubernetes services
	@echo "$(INFO) Running docker container with tag: $(REPO):local"
	@echo "$(BLUE)"
	$(DOCKER_RUN_LOCAL_COMMAND) $(REPO):local app
	@echo "$(NO_COLOR)"

#
# Hot reloaded run locally
#
build-dev:                       ##@local Builds the local Dockerfile
	mkdir -p wheelhouse 
	@echo "$(INFO) Building the 'dev' Container locally with tag: $(REPO):local"
	docker image build --build-arg APP_ENV=dev --build-arg PYPI_INDEX=$(CURRENT_BRANCH) -t $(REPO):local -f Dockerfile .
	@echo ""

run-dev: build-dev                   ##@local Builds and run docker container with tag: '$(REPO):local' as a one-off. ##@local (dev-workflow-2) Runs docker container on same network as minikube making it accessible from kubernetes minikube and other kubernetes services
	@echo "$(INFO) Running docker container with tag: $(REPO):local"
	@echo "$(BLUE)"
	$(DOCKER_RUN_LOCAL_COMMAND) $(REPO):local app
	@echo "$(NO_COLOR)"



































## Development Workflow 2 (See above for information or make help-show-normal-usage)










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



build-debug:                   ##@local Builds the local Dockerfile.dev (Development Dockerfile (Not run in production)). Useful if you need to debug a container (Installs helpful tools)
	mkdir -p wheelhouse 
	@echo "$(WARN) Building the Container locally with tag: $(REPO):local using Development Dockerfile (Do not run unless you need to and know what you are doing)"
	@docker image build -t $(REPO):local -f Dockerfile.dev .

build-dm:                       ##@local Builds the local Dockerfile for docker-machine environment
	mkdir -p wheelhouse 
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

shell: build                 ##@local Run bash shell against the dockerized service 
	@echo "$(INFO) Running lint tests against the docker container"
	$(DOCKER_RUN_COMMAND) -it $(REPO):local /bin/bash

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

check: build                 ##@local-test Run regression tests against the dockerized service (Run before commit/merge i.e. don't break regression)
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
# Minikube
#
POD_NAME=`kubectl get pods -o wide | grep $(PROJECT_NAME) | grep Running | cut -d ' ' -f1`

PHONY: mkube-update mkube-logs mkube-env mkube-attach mkube-six-hour-logsk

mkube-update:           ##@kube Updates service in minikube
	@echo "$(INFO) Deploying $(REPO):$(TIMESTAMP) by replacing image in minikube kubernetes deployment config"
	# TODO: add cluster check  - i.e. is minikube pointed at
	@eval $$(minikube docker-env); docker image build -t $(REPO):$(TIMESTAMP) -f Dockerfile .
	kubectl set image -f $(NEWTON_DIR)/devops/k8s/deploy/local/hello-deployment.yml hello=$(REPO):$(TIMESTAMP)

mkube-logs:                   ##@kube-debug Tails logs for the container
	@echo "$(INFO) Attaching to pod $(BLUE)$(POD_NAME)$(RESET) logs"
	@kubectl logs -f --tail=50 $(POD_NAME)

mkube-env:                    ##@kube-debug Prints environment variables for the container 
	@echo "$(INFO) Printing the environment variables for $(BLUE)$(POD_NAME)$(RESET)"
	@kubectl exec $(POD_NAME) printenv

mkube-attach:                 ##@kube-debug Attachs to the container with a shell
	@echo "$(INFO) Attaching a shell to $(BLUE)$(POD_NAME)$(RESET)"
	kubectl exec -it $(POD_NAME) -- /bin/bash

mkube-six-hour-logs:          ##@kube-debug Last six hours worth of logs for $(PROJECT_NAME)
	@echo "$(INFO) $(BLUE)$(POD_NAME)$(RESET) logs for the last $(BLUE)six$(RESET) hours"
	@kubectl logs --since=6h $(POD_NAME)


#
# Deploy (in-staging testing)
#

deploy-cloud-dev:                ##@local-deploy Deploy service to cloud environment (for in staging testing)
	@echo "Not implemented yet ... sorry boss"
	kubectl config set-context dev 
	kubectl config set-cluster dev
	kubectl sjkjfdsjflkds
	kubectl config set-context minikube
