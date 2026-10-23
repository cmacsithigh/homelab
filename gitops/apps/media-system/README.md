# Media system

## Web UIs

LAN addresses are defined by the services in this directory:

| App          | URL                          |
| ------------ | ---------------------------- |
| Dispatcharr  | `http://192.168.18.227`      |
| Jellyfin     | `http://192.168.18.221:8096` |
| Maintainerr  | `http://192.168.18.225:6246` |
| NZBGet       | `http://192.168.18.229:6789` |
| Prowlarr     | `http://192.168.18.222:9696` |
| Radarr       | `http://192.168.18.223:7878` |
| Seerr        | `http://192.168.18.220:5055` |
| Sonarr       | `http://192.168.18.224:8989` |
| Transmission | `http://192.168.18.228`      |
| Wizarr       | `http://192.168.18.226:5690` |

## Required secrets

Dispatcharr and Transmission use the `openvpn-user` and `openvpn-password`
secrets in the `media-system` namespace.

Dispatcharr's CloudNativePG cluster requires an application credential secret.
Create it before deploying Dispatcharr:

```bash
kubectl -n media-system create secret generic dispatcharr-db-app \
  --from-literal=username=dispatch \
  --from-literal=password="$(openssl rand -hex 32)" \
  --type=kubernetes.io/basic-auth
```

Keep this secret unchanged while its PostgreSQL cluster is in use. Dispatcharr
starts with a new database; its existing `/data` PVC is separate.

## NZBGet notifications

The pod installs `ntfy.py` to `/config/scripts` at startup. In NZBGet, enable it
under **Settings > Extension Scripts** and set:

- `NTFY_URL`: `http://ntfy.ntfy-system.svc.cluster.local`
- `NTFY_TOPIC`: `homelab`

## Transmission

To access Transmission locally:

```bash
kubectl -n media-system port-forward service/transmission 9091:80
```

Then open `http://localhost:9091`.
