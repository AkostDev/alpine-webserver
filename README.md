# Alpine 3.15 Web Server
Docker container in Alpine image with PHP 8 and NGINX 1.20

## Installation

1. Clone this repository
2. Change config files in directory `config`
3. Run `docker build -t alpine-webserver:latest . --no-cache`

## Example _docker-compose.yml_

```yaml
version: "3.1"

services:
  php-fpm:
    image: alpine-webserver:latest
    container_name: php-fpm
    restart: always
    ports:
      - "8000:80"
    volumes:
      - ./:/var/www/html
```
