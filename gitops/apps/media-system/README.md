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