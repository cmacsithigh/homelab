# Cloudflared

## Creating openabo secret

### Create secret

```bash
bao kv put secret/keycloak-credentials password=<keycloak-admin-password>
```

### Ceate policy

```bash
echo 'path "secret/data/keycloak-credentials" { capabilities = ["read"] }' | bao policy write keycloak-reader -
```

### write role

```bash
bao write auth/kubernetes/role/keycloak-reader \
    bound_service_account_names="keycloak-system-keycloak" \
    bound_service_account_namespaces="keycloak-system" \
    policies="keycloak-reader" \
    ttl="1h"
```