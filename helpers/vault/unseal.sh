set -e

ITER=0
for key in $(cat ../../playgroud/vault | grep -o ': .*' | sed 's@: @@'); do
    if [[ $ITER -eq 5 ]]; then
        break
    else
        kubectl -n infra-system exec -ti vault-0 -- vault operator unseal "$key"
    fi
    ITER=$(expr $ITER + 1)
done
echo "Vault unsealed"