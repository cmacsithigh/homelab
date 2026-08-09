cp -a /playlists/. /var/lib/mpd/playlists/ 2>/dev/null || true
cp -a /lua_scripts/. /var/lib/mympd/scripts/ 2>/dev/null || true


mkdir -p /var/lib/mympd/pics/playlists
cp -a /pictures/. /var/lib/mympd/pics/playlists/ 2>/dev/null || true