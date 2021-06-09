# Vault Deployment

In this helpers it will show you how to deploy vault standalone version. Before we start make sure you already copy kube config from k8s-master instance to you local machine.

First we need to create storage class (in this case we use local-storage) :

1. `kubectl -n infra-system create storageClass.yml`

After create storage class we need create persistent volume on `node-1` :

1. `vagrant ssh node-1 -c "sudo mkdir -p /data/vault`

2. `kubectl -n infra-system create persistentVolume.yml`

Run `deploy.sh` to setup vault in standalone mode.

Run `init.sh` for init vault

Key and Root token will be avaliable in `playgroud` folder

# Vault Agent Injector

How to create agent injector with vault :
1. `kubectl -n infra-system exec -ti vault-0 -- /bin/sh` to get in into vault instance
2. `export VAULT_TOKEN=root_token` to set vault token
3. First we need to create token policy

```cat <<EOF > /home/vault/app-policy.hcl
path "config/*" {
  capabilities = ["read"]
}
EOF
```

This policy will able to read secret in path `config/*`

4. `vault policy write app /home/vault/app-policy.hcl` to register policy to vault server
5. `vault auth enable kubernetes` to enable kubernetes authentication
6. To configure kubernetes auth :

```
vault write auth/kubernetes/config \
   token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
   kubernetes_host=https://${KUBERNETES_PORT_443_TCP_ADDR}:443 \
   kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
```

7. Create vault role that bound with service account kubernetes
```
vault write auth/kubernetes/role/myapp \
   bound_service_account_names=app \
   bound_service_account_namespaces=services \
   policies=app \
   ttl=1h
```