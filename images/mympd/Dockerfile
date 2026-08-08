FROM ghcr.io/jcorporation/mympd/mympd:25.3.0

USER root

RUN apk add bash tzdata

RUN cp /usr/share/zoneinfo/Europe/Dublin /etc/localtime \
    && echo "Europe/Dublin" > /etc/timezone

COPY scripts/ /scripts/

RUN umask 000

ENTRYPOINT ["/usr/bin/mympd"]

RUN /bin/sh /scripts/run.sh

CMD [ "/bin/sh", "/code/cmd.sh"]
