FROM debian:13-slim
LABEL Author="cian-sheehy"

ENV DEBIAN_FRONTEND=noninteractive

ARG snapcast_version=0.28.0
ARG target_arch=amd64-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    dumb-init \
    tzdata \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

RUN cp /usr/share/zoneinfo/Europe/Dublin /etc/localtime \
    && echo "Europe/Dublin" > /etc/timezone

RUN curl -sL https://github.com/dtcooper/raspotify/releases/download/0.45.0/raspotify_0.45.0.librespot.v0.5.0-84d28e8_amd64.deb -o /tmp/raspotify.deb \
    && dpkg -i /tmp/raspotify.deb || true \
    && apt-get update \
    && apt-get -f install -y \
    && rm -f /tmp/raspotify.deb \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://github.com/badaix/snapcast/releases/download/v${snapcast_version}/snapserver_${snapcast_version}-1_${target_arch}.deb -o /tmp/snapserver.deb \
    && dpkg -i /tmp/snapserver.deb || true \
    && apt-get update \
    && apt-get -f install -y \
    && rm -f /tmp/snapserver.deb \
    && rm -rf /var/lib/apt/lists/*

RUN /usr/bin/snapserver -v

COPY snapserver.conf /etc/snapserver.conf

EXPOSE 1704 1705 1780

ENTRYPOINT ["/usr/bin/snapserver", "librespot", "--cache", "/var/lib/snapserver", "--enable-oauth", "--oauth-port", "0"]

HEALTHCHECK --interval=60s --timeout=5s \
    --retries=3 \
    CMD curl --connect-timeout 5 \
    --silent --show-error \
    --fail http://localhost:1780/ || exit 1
