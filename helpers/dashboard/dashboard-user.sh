#create service account in kubernetes-dashboard namespace
kubectl apply -f serviceAccount.yml
#add cluster role to user account 
kubectl apply -f ClusterRoleBinding.yml
