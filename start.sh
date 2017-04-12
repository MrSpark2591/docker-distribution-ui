#!/bin/bash

die() {
  echo "ERROR: $1"
  exit 2
}

[[ -z "$ENV_DOCKER_REGISTRY_HOST" ]] && die "Missing environment variable: ENV_DOCKER_REGISTRY_HOST=url-to-your-registry" 
[[ -z "$ENV_DOCKER_REGISTRY_PORT" ]] && ENV_DOCKER_REGISTRY_PORT=80 
[[ -z "$ENV_REGISTRY_PROXY_FQDN" ]] && ENV_REGISTRY_PROXY_FQDN=$ENV_DOCKER_REGISTRY_HOST
[[ -z "$ENV_REGISTRY_PROXY_PORT" ]] && ENV_REGISTRY_PROXY_PORT=$ENV_DOCKER_REGISTRY_PORT

needModSsl=0
if [ -n "$ENV_DOCKER_REGISTRY_USE_SSL" ]; then
  echo "export DOCKER_REGISTRY_SCHEME=https" >> /etc/apache2/envvars
  needModSsl=1
else
  echo "export DOCKER_REGISTRY_SCHEME=http" >> /etc/apache2/envvars
fi

echo $ENV_DOCKER_REGISTRY_HOST

sed -i "s/REGISTRY_PORT/$ENV_DOCKER_REGISTRY_PORT/" /etc/nginx/conf.d/default.conf
sed -i "s/REGISTRY_HOST/$ENV_DOCKER_REGISTRY_HOST/" /etc/nginx/conf.d/default.conf


nginx -g "daemon off;"
