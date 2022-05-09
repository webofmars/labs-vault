#!/bin/bash

set -eu -o pipefail
set -x

KUBECONFIG="$(realpath ./labs.kubeconfig)"
K8S_VERSION="1.23.4"
K8S_CNI="calico"
K8S_INGRESS="none"
export K8S_CLUSTER_NAME="labs"
export K8S_REGION="fr-par"

echo "+ creating cluster"
scw --profile labs \
  k8s cluster create \
  name=labs region="${K8S_REGION}" version="${K8S_VERSION}" cni="${K8S_CNI}" ingress="${K8S_INGRESS}" \
  pools.0.size=1 pools.0.node-type=DEV1_L pools.0.min-size=1 pools.0.max-size=3 \
  pools.0.autohealing=true pools.0.autoscaling=true pools.0.name=workers

sleep 120

echo "+ get cluster_id"
cluster_id=$(scw k8s cluster list --profile=labs region="$K8S_REGION" -o json | jq \
  --arg CLUSTER_NAME "$K8S_CLUSTER_NAME" \
  -r '.[] | select(.name="$CLUSTER_NAME") | .id')

if [ -n "$cluster_id" ]; then
  echo "+ get kubeconfig"
  scw k8s kubeconfig get "${cluster_id}" --profile=labs region=$K8S_REGION > "${KUBECONFIG}"
  chmod 600 "${KUBECONFIG}"
fi
