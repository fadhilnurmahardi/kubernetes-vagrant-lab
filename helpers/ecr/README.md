# ECR Integrations

This helper is to setup integration between kubernetes with private registry ECR.

1. First you need create user that can access `secrets` in kubernetes cluster. You can apply with `kubectl apply -f user-role.yml`

2. We need cron job to fetch token from AWS ECR and push it to kubernetes `secrets`. You can apply with `kubectl apply -f cron-ecr.yml`. Make sure you replace `xxx` with real value.

After that any deployment need pull from ECR configuration can be achieve with add `imagePullSecrets`. (more detail: `https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#create-a-pod-that-uses-your-secret`)

This helper is enhancement from this article `https://medium.com/@damitj07/how-to-configure-and-use-aws-ecr-with-kubernetes-rancher2-0-6144c626d42c`