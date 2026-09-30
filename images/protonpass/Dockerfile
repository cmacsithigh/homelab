FROM debian:bookworm-slim AS installer

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    jq \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://proton.me/download/pass-cli/install.sh | bash

RUN KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt) && \
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/arm64/kubectl" && \
    chmod +x ./kubectl

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    bash \
    jq \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash protonuser
WORKDIR /home/protonuser

COPY --from=installer /root/.local/bin/pass-cli /usr/local/bin/pass-cli
COPY --from=installer /kubectl /usr/local/bin/kubectl

RUN chmod 755 /usr/local/bin/pass-cli /usr/local/bin/kubectl

USER protonuser

CMD ["bash"]