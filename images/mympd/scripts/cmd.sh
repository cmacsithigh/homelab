#/bin/sh

chown -R 1000:1000 /var/lib/mympd
chmod -R 777 /var/lib/mympd

chown -R 1000:1000 /var/cache/mympd
chmod -R 777 /var/cache/mympd

mkdir -p /var/lib/mpd/playlists
mkdir -p /var/lib/mympd/pics/playlists

cp -a /playlists/. /var/lib/mpd/playlists/ 2>/dev/null || true

chown -R 1000:1000 /var/lib/mympd/pics/thumbs
chmod -R 777 /var/lib/mympd/pics/thumbs

mkdir -p /var/lib/mympd/scripts
chown -R 1000:1000 /var/lib/mympd/scripts
chmod -R 777 /var/lib/mympd/scripts
cp -a /lua_scripts/. /var/lib/mympd/scripts/ 2>/dev/null || true

mv /var/lib/mpd/pictures/*.{jpg,png} /var/lib/mympd/pics/playlists/ 2>/dev/null || true
