set -e

ITER=0
IFS=$'\n'
for key in $(cat /vagrant/playgroud/vault | grep -o ': .*' | sed 's@: @@' | sed 's@ @@'); do
    echo $key
    if [[ $ITER -eq 5 ]]; then
        break
    else 
        kubectl -n infra-system exec -ti vault-0 -- vault operator unseal $key
    fi
    ITER=$(expr $ITER + 1)
done
echo "Vault unsealed"