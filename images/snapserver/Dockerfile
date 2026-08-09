# FROM debian:13-slim
# LABEL Author="cian-sheehy"

# ENV DEBIAN_FRONTEND=noninteractive

# ARG snapcast_version=0.28.0
# ARG target_arch=armhf-bookworm

# RUN apt update && apt upgrade -y \
#     curl \
#     dumb-init \
#     tzdata

# RUN cp /usr/share/zoneinfo/Europe/Dublin /etc/localtime \
#     && echo "Europe/Dublin" > /etc/timezone

# # install snapserver
# RUN curl -sLO https://github.com/badaix/snapcast/releases/download/v${snapcast_version}/snapserver_${snapcast_version}-1_${target_arch}.deb \
#     && dpkg --add-architecture armhf \
#     && dpkg -i snapserver_${snapcast_version}-1_${target_arch}.deb \
#     ; apt update && apt -f install -y \
#     && rm snapserver_${snapcast_version}-1_${target_arch}.deb

# # install raspotify which in turns sets up librespot
# RUN curl -sLO https://github.com/dtcooper/raspotify/releases/download/0.45.0/raspotify_0.45.0.librespot.v0.5.0-84d28e8_armhf.deb \
#     && apt install -y ./raspotify_0.45.0.librespot.v0.5.0-84d28e8_armhf.deb

# RUN systemctl disable raspotify

# RUN /usr/bin/snapserver -v

# COPY snapserver.conf /etc/snapserver.conf

# EXPOSE 1704 1705 1780

# ENTRYPOINT ["/usr/bin/snapserver librespot --cache /var/lib/snapserver --enable-oauth --oauth-port 0"]

# HEALTHCHECK --interval=60s --timeout=5s \
#     --retries=3 \
#     CMD curl --connect-timeout 5 \
#     --silent --show-error \
#     --fail http://localhost:1780/ || exit 1


FROM alpine:3.19

USER root
WORKDIR /

# To be set if there is a need to run the user with a specific PID
ARG UID=100

RUN apk --no-cache upgrade && \
    apk add --no-cache dumb-init shadow python3 py3-websocket-client snapcast-server && \
    rm -rf /tmp/*

ENV DATA_DIR=/var/lib/snapcast
WORKDIR $DATA_DIR

RUN usermod -u $UID snapcast && \
    chown snapcast:snapcast -R $DATA_DIR

USER snapcast:snapcast

COPY snapserver.conf /etc/snapserver/snapserver.conf

EXPOSE 1704 1705 1780 4900-4910

ENTRYPOINT ["snapserver", "-c", "/etc/snapserver/snapserver.conf"]