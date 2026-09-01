cp -a /playlists/. /var/lib/mpd/playlists/ 2>/dev/null || true
cp -a /lua_scripts/. /var/lib/mympd/scripts/ 2>/dev/null || true


mkdir -p /var/lib/mympd/pics/playlists
cp -a /pictures/. /var/lib/mympd/pics/playlists/ 2>/dev/null || true

cp -a /state/. /var/lib/mympd/state/ 2>/dev/null || true

chown -R 1000:1000 /var/lib/mympd /var/cache/mympd /var/lib/mympd/pics/thumbs /var/lib/mympd/scripts
chmod -R 777 /var/lib/mympd /var/cache/mympd /var/lib/mympd/pics/thumbs /var/lib/mympd/scripts