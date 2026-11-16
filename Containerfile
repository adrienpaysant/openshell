# OCI agent image for the OpenShell POC. Build with Podman on Apple Silicon.
FROM nvcr.io/nvidia/base/ubuntu:24.04

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       bash ca-certificates curl coreutils iproute2 procps \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /bin/bash agent
RUN mkdir -p /workspace && chown agent:agent /workspace
USER agent
WORKDIR /workspace
CMD ["/bin/bash"]
