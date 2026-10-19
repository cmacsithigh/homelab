# Media system

Here we will document all the manual bits and bobs

## Fetching openvpn credentials

We need to fetch the openvpn credentials from protonvpn. These will be used for authentiaction for gluetun

## NZBGet ntfy notifications

The `ntfy.py` post-processing script is installed to `/config/scripts`
(NZBGet's `MainDir/scripts`) from the `nzbget-scripts` ConfigMap whenever the
pod starts. In NZBGet, open
**Settings > Extension Scripts**, enable `ntfy.py`, and set:

- `NTFY_URL`: `http://ntfy.ntfy-system.svc.cluster.local`
- `NTFY_TOPIC`: `homelab`

The script sends a notification for each completed download. Successful,
warning, and failed downloads get different ntfy priorities and tags.

## Dispatcharr and Sportarr

Dispatcharr and Sportarr are available on the media-system LAN addresses:

- Dispatcharr: `http://192.168.18.227:9191`
- Sportarr: `http://192.168.18.230:1867`

Dispatcharr runs its all-in-one image with persistent application data. Complete
its initial web setup after the pod is ready. Sportarr stores its configuration
separately and uses the shared `/data` media storage, matching the paths used by
the other media apps.

## Lidarr and Mixarr

In Lidarr, add NZBGet under **Settings > Download Clients**:

- Host: `nzbget.media-system.svc.cluster.local`
- Port: `6789`
- Enter the NZBGet username and password configured in NZBGet.

Configure NZBGet's completed and intermediate directories as
`/data/usenet/complete` and `/data/usenet/incomplete`, respectively, and use
those same paths in Lidarr's NZBGet client settings.

Set the Lidarr root folder to `/data/music`. In **Settings > Media Management**,
enable completed download handling.

Mixarr connects to Lidarr using its API. From Mixarr, configure the Lidarr URL
as `http://lidarr.media-system.svc.cluster.local:8686` and enter the API key
from Lidarr **Settings > General**.

Mixarr requires MariaDB, Redis, and a session secret. Create its Kubernetes
Secret once before deploying:

```bash
kubectl -n media-system create secret generic mixarr-secrets \
  --from-literal=MYSQL_ROOT_PASSWORD="$(openssl rand -hex 32)" \
  --from-literal=MYSQL_PASSWORD="$(openssl rand -hex 32)" \
  --from-literal=SESSION_SECRET="$(openssl rand -hex 32)"
```

Configure Prowlarr to sync indexers to Lidarr using
`http://lidarr.media-system.svc.cluster.local:8686` and the Lidarr API key.

## set admin password qbittorrent

Find temporary admin password from logs and login. Reset password to something new

## Setup qbittorrent in sonarr, radarr, prowlarr

- Navigate to each UI
- Click settings > Download clients
- Click the large plus button
- Select qbittorrent
  - Set host to qbittorrent.media-system.svc.cluster.local
  - Set username to admin
  - Set admin password to what we've changed it to in previous steps

## Setup downoad location for qbittorrent

Configure the Downloads Tab:

- In the left sidebar of the Options window, click Downloads.
- Update the following fields under Saving Management:
  - Default Save Path: Set to /data/torrents/completed
  - Check Keep incomplete torrents and set the path to /data/torrents/incomplete
  - Default Torrent Management Mode: Change dropdown from Manual to Automatic
  - When Category changed: Set dropdown to Relocate torrent
  - When Default Save Path changed: Set dropdown to Relocate affected torrents
  - When Category Save Path changed: Set dropdown to Relocate affected torrents

Note: Ensure /data matches the mount point path configured in your Kubernetes PVC for qBittorrent.

## Test Transmission alongside qBittorrent

Transmission is deployed separately and uses the same VPN and media storage as qBittorrent. Its Web UI is only exposed inside the cluster. To access it locally, run:

```bash
kubectl -n media-system port-forward service/transmission 9091:9091
```

Then open `http://localhost:9091`. Enable RPC authentication in Transmission's settings before using it, and set the download directories to `/data/torrents/completed` and `/data/torrents/incomplete` to match the existing media paths.

To test it without replacing qBittorrent, add a Transmission download client in Sonarr and Radarr:

- Host: `transmission.media-system.svc.cluster.local`
- Port: `9091`
- Set the username and password configured in Transmission.

qBittorrent remains available until you are ready to switch over.

# Connecting Prowlarr to Sonarr and Radarr

## Step 1: Get API Keys from Sonarr and Radarr

1. Open **Sonarr**, navigate to **Settings** > **General**, and copy the **API Key**.
2. Open **Radarr**, navigate to **Settings** > **General**, and copy its **API Key**.

## Step 2: Add Sonarr to Prowlarr

1. In **Prowlarr**, navigate to **Settings** > **Applications**.
2. Click the **+** button and select **Sonarr**.
3. Configure the connection settings:
   - **Name:** `Sonarr`
   - **Sync Level:** `Full Sync` _(Automatically manages add/remove/updates)_
   - **Prowlarr Server:** `http://prowlarr.media-system.svc.cluster.local:9696`
   - **Sonarr Server:** `http://sonarr.media-system.svc.cluster.local:8989`
   - **API Key:** Paste your **Sonarr API Key**
4. Click **Test**. Once the green checkmark appears, click **Save**.

## Step 3: Add Radarr to Prowlarr

1. Under **Settings** > **Applications**, click the **+** button again and select **Radarr**.
2. Configure the connection settings:
   - **Name:** `Radarr`
   - **Sync Level:** `Full Sync`
   - **Prowlarr Server:** `http://prowlarr.media-system.svc.cluster.local:9696`
   - **Radarr Server:** `http://radarr.media-system.svc.cluster.local:7878`
   - **API Key:** Paste your **Radarr API Key**
3. Click **Test**. Once verified, click **Save**.

## Step 4: Add Your First Indexers in Prowlarr

1. Go to **Indexers** in the left sidebar of Prowlarr.
2. Click **Add Indexer** and select your preferred public or private torrent indexers (e.g., 1337x, EZTV, YTS).
3. Save the indexer.
