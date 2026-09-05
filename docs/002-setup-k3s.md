# Setup k3s cluster

This part if all automated and all we need to do is run this playbook

```bash
ansible-playbook ./ansible/playbooks/002-k3s-setup.yaml -K
```

You might need to run this playbook with `-K` on the first time to ensure sudo password is asked. This is due to a higher level of permissions being required.

Once we have k3s installed across all of our server node and worker nodes we need to ensure our localhost setup is pointing to the correct cluster. This is achived by running the following playbook

```bash
ansible-playbook ./ansible/playbooks/003-local-setup.yaml
```

## Keycloak OIDC issuer

The server playbook configures the Kubernetes API server to trust Keycloak at:

```text
https://keycloak.ciansheehy.co/realms/homelab
```

Before applying the playbook, create a `homelab` realm in Keycloak and a client
with client ID `headlamp` and add this valid redirect URI:

```text
https://headlamp.ciansheehy.co/oidc-callback
```

Tokens used with the cluster must contain:

- `aud`: `headlamp`
- `preferred_username`: the Kubernetes username
- `groups`: Kubernetes group names

Add a `kubernetes-admins` group mapper to the Headlamp client and add users to
that group. The repository binds that group to the Kubernetes `cluster-admin`
role. Store the Headlamp client values in OpenBao before Flux reconciles the
Headlamp app:

```bash
bao kv put secret/headlamp-oidc \
	clientID=headlamp \
	clientSecret=<keycloak-client-secret> \
	issuerURL=https://keycloak.ciansheehy.co/realms/homelab \
	scopes='openid,profile,email,groups' \
	callbackURL=https://headlamp.ciansheehy.co/oidc-callback
```

Create the `headlamp-reader` OpenBao policy and Kubernetes auth role for the
`headlamp` service account, following the same pattern as the Keycloak secret
in `gitops/apps/keycloak/README.md`, but using `headlamp-oidc` as the secret
path and `headlamp-system` as the namespace.

Finally, add `headlamp.ciansheehy.co` to the Cloudflare tunnel and route it to
the `headlamp` service in the `headlamp-system` namespace on port 80.

After changing the API server arguments, restart K3s on every server node. The
issuer discovery endpoint should then be reachable at
`https://keycloak.ciansheehy.co/realms/homelab/.well-known/openid-configuration`.