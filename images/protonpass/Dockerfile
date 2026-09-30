# --- Stage 1: Installer ---
FROM alpine:3.18 AS installer

# Install dependencies needed for both install workflows
RUN apk add --no-cache curl jq bash

# 1. Download and run the Proton Pass CLI installer
RUN curl -fsSL https://proton.me/download/pass-cli/install.sh | bash

# 2. Download the latest stable kubectl binary
RUN KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt) && \
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl

# --- Stage 2: Final Production Image ---
FROM alpine:3.18

# Install dependencies (gcompat resolves glibc/musl compatibility differences for precompiled binaries)
RUN apk add --no-cache gcompat ca-certificates bash

# Create a non-root user for operational security
RUN adduser -D protonuser
USER protonuser
WORKDIR /home/protonuser

# Copy both compiled tools into the system PATH
COPY --from=installer /root/.local/bin/pass-cli /usr/local/bin/pass-cli
COPY --from=installer /kubectl /usr/local/bin/kubectl

# Standard entrypoint fallback
CMD ["bash"]
