# PHP (FPM) for Laravel

Base image: `php:8.3-fpm-alpine3.19`

## Use

```shell
docker pull ghcr.io/efureev/docker-php:latest
```

```dockerfile
FROM ghcr.io/efureev/docker-php:latest
```

## Containers

- https://github.com/efureev/docker-php/pkgs/container/docker-php

## PHP Ext List

- [redis](https://pecl.php.net/package/redis)
- pgsql
- intl
- [excimer](https://pecl.php.net/package/excimer)

## Tools

- bash
- fcgi
- curl
- composer

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
