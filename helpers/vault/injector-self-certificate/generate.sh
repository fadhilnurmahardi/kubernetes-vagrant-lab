set -e

openssl genrsa -out cert/injector-ca.key 2048

openssl req \
   -x509 \
   -new \
   -nodes \
   -key cert/injector-ca.key \
   -sha256 \
   -days 7300 \
   -out cert/injector-ca.crt \
   -subj "/C=US/ST=CA/L=San Francisco/O=HashiCorp/CN=vault-agent-injector-svc"

openssl genrsa -out cert/tls.key 2048

openssl req \
   -new \
   -key cert/tls.key \
   -out cert/tls.csr \
   -subj "/C=US/ST=CA/L=San Francisco/O=HashiCorp/CN=vault-agent-injector-svc"

cat <<EOF >cert/csr.conf
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = vault-agent-injector-svc
DNS.2 = vault-agent-injector-svc.infra-system
DNS.3 = vault-agent-injector-svc.infra-system.svc
DNS.4 = vault-agent-injector-svc.infra-system.svc.cluster.local
EOF

openssl x509 \
  -req \
  -in cert/tls.csr \
  -CA cert/injector-ca.crt \
  -CAkey cert/injector-ca.key \
  -CAcreateserial \
  -out cert/tls.crt \
  -days 7300 \
  -sha256 \
  -extfile cert/csr.conf


kubectl -n infra-system delete secret injector-tls --ignore-not-found

kubectl create secret generic injector-tls \
    --from-file cert/tls.crt \
    --from-file cert/tls.key \
    --namespace=infra-system

CA_BUNDLE=$(cat cert/injector-ca.crt | base64)
echo $CA_BUNDLE