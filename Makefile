GOCMD=go
GOTEST=$(GOCMD) test
GOVET=$(GOCMD) vet

GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
CYAN   := $(shell tput -Txterm setaf 6)
RESET  := $(shell tput -Txterm sgr0)

.PHONY: all test build vendor

all: help

## Build:
build: ## Build the list trending repos binary.
	CGO_ENABLED=0 GO111MODULE=on $(GOCMD) build "-ldflags=$$(version/ldflags.bash)" -o go-list-trending-repos .

build-docker: ## Build the docker image
	chmod +x ./version/ldflags-docker.bash
	export LDFLAGS="$(./version/ldflags-docker.bash)" && docker build --platform=linux/amd64 --build-arg LDFLAGS="$(LDFLAGS)" -t $(IMAGE_NAME) .

## Help:
help: ## Show this help.
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    ${YELLOW}%-20s${GREEN}%s${RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${CYAN}%s${RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)