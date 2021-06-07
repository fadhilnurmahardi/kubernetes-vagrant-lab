# kubernetes-vagrant-lab

A simple 3-node lab running Ubuntu servers on VirtualBox and in each server have 1 Kubemaster and 2 node.

# How to setup

1. Install vagrant & virtualbox
2. Install ansible (for provision vagrant)
3. `vagrant up` and all of the server will running
4. `vagrant ssh k8s-master` to check the cluster you could run `kubectl get cnodes`