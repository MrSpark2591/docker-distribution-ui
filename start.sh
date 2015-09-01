#!/bin/bash

die() {
  echo "ERROR: $1"
  exit 2
}

[[ -z "$ENV_DOCKER_REGISTRY_HOST" ]] && die "Missing environment variable: ENV_DOCKER_REGISTRY_HOST=url-to-your-registry" 
[[ -z "$ENV_DOCKER_REGISTRY_PORT" ]] && ENV_DOCKER_REGISTRY_PORT=80 
[[ -z "$ENV_REGISTRY_PROXY_FQDN" ]] && ENV_REGISTRY_PROXY_FQDN=$ENV_DOCKER_REGISTRY_HOST
[[ -z "$ENV_REGISTRY_PROXY_PORT" ]] && ENV_REGISTRY_PROXY_PORT=$ENV_DOCKER_REGISTRY_PORT

echo $ENV_DOCKER_REGISTRY_HOST

echo "configuring port"
sed -i "s/REGISTRY_PORT/$ENV_DOCKER_REGISTRY_PORT/" /etc/nginx/conf.d/default.conf
echo "configuring host:"
sed -i "s/REGISTRY_HOST/$ENV_DOCKER_REGISTRY_HOST/" /etc/nginx/conf.d/default.conf


nginx -g "daemon off;"
