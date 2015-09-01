# About

The `docker-distribution-ui` is forked from [docker-registry-frontend](https://github.com/kwk/docker-registry-frontend) and updated to registry v2.
It's meant as a web frontend for browsing docker registry.

It's still a work in progress


## Run it
`docker run -e ENV_DOCKER_REGISTRY_HOST=<hostname> -e ENV_DOCKER_REGISTRY_PORT=<port> -p 8080:80 mariolameiras/docker-distribution-ui`
