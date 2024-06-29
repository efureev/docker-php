# PHP in Docker

Ready for use in Laravel.

Basic image: `alpine:latest`

## Images version

All images have `DEV` or `PROD` versions.

## Images list

- 8.2-cli
- 8.2-fpm
- 8.3-cli
- 8.3-fpm

## Use

```shell
docker pull ghcr.io/efureev/docker-php:8.3-fpm-prod-alpine
docker pull ghcr.io/efureev/docker-php:8.3-cli-dev-alpine
```

```dockerfile
FROM ghcr.io/efureev/docker-php:8.3-fpm-prod-alpine
```

## Containers

- https://github.com/efureev/docker-php/pkgs/container/docker-php

## PHP Ext List

### PROD version

- bcmath
- igbinary
- intl
- opcache
- pcntl
- pdo_pgsql
- pgsql
- redis
- zip

### DEV version

- all PROD version`s exts
- [excimer](https://pecl.php.net/package/excimer)
- xdebug

## Tools

### PROD version

- bash
- composer
- curl
- fcgi

### DEV version

- all PROD version`s tools
- git

## NB

Healthcheck included, bases on `fcgi`.
Enable in docker compose:

```dockerfile
    app:
        ...
        healthcheck:
          test: [ 'CMD-SHELL', 'docker-healthcheck' ]
          interval: 10s
          timeout: 3s
          retries: 3
```
