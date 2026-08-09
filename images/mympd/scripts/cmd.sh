#/bin/sh

chown -R 1000:1000 /var/lib/mympd
chmod -R 777 /var/lib/mympd

chown -R 1000:1000 /var/cache/mympd
chmod -R 777 /var/cache/mympd

chown -R 1000:1000 /var/lib/mympd/pics/thumbs
chmod -R 777 /var/lib/mympd/pics/thumbs

chown -R 1000:1000 /var/lib/mympd/scripts
chmod -R 777 /var/lib/mympd/scripts
