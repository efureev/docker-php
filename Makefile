
.PHONY: all build

all: help

must: ## Build docker image
	docker run --rm -ti -u "$(shell id -u):$(shell id -g)" -v "$(shell pwd):/rootfs:rw" -w /rootfs ghcr.io/tarampampam/mustpl --help

compose:
	docker run -it --rm \
               --user $(shell id -u):$(shell id -g) -v "$(shell pwd):/rootfs:rw" -w "/rootfs" \
           ghcr.io/bossm8/dockerfile-templater:debug \
               --dockerfile.tpl dockerfile.tpl \
               --dockerfile.tpldir ./includes \
               --variants.def variants.yml.tmp \
               --variants.cfg variants.cfg.yml \
               --out.dir ./dockerfiles \
               --verbose --debug

lint:
	docker run -i --rm ghcr.io/hadolint/hadolint < dockerfiles/Dockerfile.php.8.3-fpm-prod-alpine

build: ## Build docker image
	docker build -t ghcr.io/efureev/docker-php .

push: ## Push image
	docker push ghcr.io/efureev/docker-php

up: ## Run image
	docker container run --name php83 -ti ghcr.io/efureev/docker-php

help: ## Display this help screen
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
