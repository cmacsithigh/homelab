# Cloudflared

## Creating openabo secret

### Create secret

```bash
bao kv put secret/cloudflared-credentials token=<>
```

### Ceate policy

```bash
echo 'path "secret/data/cloudflared-credentials" { capabilities = ["read"] }' | bao policy write cloudflared-reader -
```

### write role

```bash
bao write auth/kubernetes/role/cloudflared-reader \
    bound_service_account_names="cloudflared" \
    bound_service_account_namespaces="cloudflared" \
    policies="cloudflared-reader" \
    ttl="1h"
```