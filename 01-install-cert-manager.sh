#!/bin/bash

set -eu -o pipefail
set -x

kubectl apply -f ./manifests/cert-manager-crds.yaml

helm upgrade cert-manager cert-manager/cert-manager \
  --install \
  --namespace cert-manager \
  --create-namespace \
  --version 1.8.0

kubectl apply -f ./manifests/le-issuer.yaml
