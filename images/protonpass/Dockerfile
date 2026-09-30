FROM alpine:3.18 AS installer

RUN apk add --no-cache curl jq bash

RUN curl -fsSL https://proton.me/download/pass-cli/install.sh | bash

RUN KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt) && \
    ARCH_MAPPING=$([ "$TARGETARCH" = "arm64" ] && echo "arm64" || echo "amd64") && \
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${ARCH_MAPPING}/kubectl" && \
    chmod +x ./kubectl

FROM alpine:3.18

RUN apk add --no-cache libc6-compat ca-certificates bash

RUN adduser -D protonuser
WORKDIR /home/protonuser

COPY --from=installer /root/.local/bin/pass-cli /usr/local/bin/pass-cli
COPY --from=installer /kubectl /usr/local/bin/kubectl

RUN chmod 755 /usr/local/bin/pass-cli /usr/local/bin/kubectl

USER protonuser

CMD ["bash"]