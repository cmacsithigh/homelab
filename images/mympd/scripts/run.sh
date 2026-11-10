#/bin/sh

if [[ ! -f /var/lib/mympd ]];
then
    mkdir /var/lib/mympd
fi

chown -R 1000:1000 /var/lib/mympd
chmod -R 777 /var/lib/mympd

if [[ ! -f /var/cache/mympd ]];
then
    mkdir /var/cache/mympd
fi
chown -R 1000:1000 /var/cache/mympd
chmod -R 777 /var/cache/mympd