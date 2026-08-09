#/bin/sh

chown -R 1000:1000 /var/lib/mympd
chmod -R 777 /var/lib/mympd

chown -R 1000:1000 /var/cache/mympd
chmod -R 777 /var/cache/mympd

mkdir -p /var/lib/mympd/pics/playlists

chown -R 1000:1000 /var/lib/mympd/pics/thumbs
chmod -R 777 /var/lib/mympd/pics/thumbs

chown -R 1000:1000 /var/lib/mympd/scripts
chmod -R 777 /var/lib/mympd/scripts

mv /var/lib/mpd/pictures/*.{jpg,png} /var/lib/mympd/pics/playlists/ 2>/dev/null || true
