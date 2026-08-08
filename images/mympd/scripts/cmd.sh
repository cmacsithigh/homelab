#/bin/sh

chown -R 1000:1000 /var/lib/mympd
chmod -R 777 /var/lib/mympd

chown -R 1000:1000 /var/cache/mympd
chmod -R 777 /var/cache/mympd

chown -R 1000:1000 /var/lib/mympd/pics/thumbs
chmod -R 777 /var/lib/mympd/pics/thumbs

chown -R 1000:1000 /var/lib/mympd/scripts
chmod -R 777 /var/lib/mympd/scripts

mv /mystate/view_browse_radio_webradiodb /var/lib/mympd/state/view_browse_radio_webradiodb
