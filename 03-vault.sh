#!/bin/bash

set -eu -o pipefail
set -x

helm upgrade \
  vault hashicorp/vault \
  --install \
  --namespace labs --create-namespace \
  --version 0.19.0 \
  -f values/vault.yaml
