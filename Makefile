
.PHONY: all build

all: help

build: ## Build docker image
	docker build -t ghcr.io/efureev/docker-php .

push: ## Push image
	docker push ghcr.io/efureev/docker-php

up: ## Run image
	docker container run --name php83 -ti ghcr.io/efureev/docker-php

help: ## Display this help screen
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
