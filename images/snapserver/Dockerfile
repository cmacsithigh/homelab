FROM debian:13-slim
LABEL Author="cian-sheehy"

ENV DEBIAN_FRONTEND=noninteractive

ARG snapcast_version=0.35.0
ARG target_arch=arm64_trixie

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    dumb-init \
    tzdata \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

RUN cp /usr/share/zoneinfo/Europe/Dublin /etc/localtime \
    && echo "Europe/Dublin" > /etc/timezone


RUN curl -sL https://dtcooper.github.io/raspotify/install.sh | sh

RUN curl -sL https://github.com/badaix/snapcast/releases/download/v${snapcast_version}/snapserver_${snapcast_version}-1_${target_arch}.deb -o /tmp/snapserver.deb \
    && apt-get install -y --no-install-recommends /tmp/snapserver.deb \
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
