FROM ghcr.io/jcorporation/mympd/mympd:26.0.0

USER root

RUN apk add bash tzdata

RUN cp /usr/share/zoneinfo/Europe/Dublin /etc/localtime \
    && echo "Europe/Dublin" > /etc/timezone

COPY lua_scripts/ /lua_scripts/
COPY pictures/ /pictures/
COPY playlists/ /playlists/
COPY scripts/ /scripts/

RUN chmod +x /scripts/*.sh || true

RUN umask 000

ENTRYPOINT ["/usr/bin/mympd"]

RUN /bin/sh /scripts/run.sh

CMD [ "/bin/sh", "/code/cmd.sh"]
