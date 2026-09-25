# Media system

Here we will document all the manual bits and bobs

## Fetching openvpn credentials

We need to fetch the openvpn credentials from protonvpn. These will be used for authentiaction for gluetun

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
