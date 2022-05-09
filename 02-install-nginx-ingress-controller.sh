#!/bin/bash

set -eu -o pipefail
set -x

helm upgrade ingress-nginx ingress-nginx/ingress-nginx \
    --install \
    --namespace ingress-nginx \
    --create-namespace \
    --version 4.0.17 \
    -f values/ingress-nginx.yaml
