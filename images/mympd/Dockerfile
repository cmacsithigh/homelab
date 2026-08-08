FROM ghcr.io/jcorporation/mympd/mympd:24.0.3

USER root

RUN apk add bash tzdata

RUN cp /usr/share/zoneinfo/Europe/Dublin /etc/localtime \
    && echo "Europe/Dublin" > /etc/timezone

COPY scripts/ /scripts/

COPY ../mpd/playlists /playlists

RUN umask 000

ENTRYPOINT ["/usr/bin/mympd"]

RUN /bin/sh /scripts/run.sh

CMD [ "/bin/sh", "/code/cmd.sh"]
