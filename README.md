# vault

```sh
kubectl apply -n labs -f ./manifests/vault-k8s.yaml
```

```sh
vault policy write demo - <<EOF
path "kv/*" {
    capabilities = ["read", "list"]
}
EOF
```

```sh
export VAULT_SA_NAME=$(kubectl get sa vault-auth --output jsonpath="{.secrets[*]['name']}")

export SA_JWT_TOKEN=$(kubectl get secret $VAULT_SA_NAME --output 'go-template={{ .data.token }}' | base64 --decode)

export SA_CA_CRT=$(kubectl config view --raw --minify --flatten --output 'jsonpath={.clusters[].cluster.certificate-authority-data}' | base64 --decode)

export K8S_HOST=$(kubectl config view --raw --minify --flatten --output 'jsonpath={.clusters[].cluster.server}')
```

```sh
vault auth enable kubernetes
vault write auth/kubernetes/config \
     token_reviewer_jwt="$SA_JWT_TOKEN" \
     kubernetes_host="${K8S_HOST}" \
     kubernetes_ca_cert="$SA_CA_CRT" \
     issuer="https://kubernetes.default.svc.cluster.local"
```

```sh
vault write auth/kubernetes/role/demo \
     bound_service_account_names=default \
     bound_service_account_namespaces=labs \
     policies=demo \
     ttl=24h
```
