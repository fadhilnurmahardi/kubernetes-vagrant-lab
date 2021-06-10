set -e

vault_secrets="$(kubectl -n infra-system exec -ti vault-0 -- vault operator init -key-shares=5 -key-threshold=5 || echo "false")"

if [[ "$vault_secrets" != "false" ]]; then
    echo "$vault_secrets"
    mkdir -p ../../playgroud
    tee ../../playgroud/vault>/dev/null<<EOF
"$vault_secrets"
EOF
fi