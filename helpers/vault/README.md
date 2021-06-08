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