#!/bin/bash

set -eu -o pipefail
set -x

echo "+ get cluster_id"
cluster_id=$(scw k8s cluster list --profile=labs region=fr-par -o json | jq -r '.[] |select(.name=="labs") |.id')

echo "+ deleting cluster"
scw --profile labs \
  k8s cluster delete \
  $cluster_id region=fr-par

exit 0
