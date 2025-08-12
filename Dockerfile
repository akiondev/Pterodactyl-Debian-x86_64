FROM debian:bookworm-slim

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      bash ca-certificates curl unzip file tzdata tar openssl sed \
      python3 python3-pip python3-venv \
      libmaxminddb0 libmaxminddb-dev mmdb-bin \
      iptables nftables \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip install --no-cache-dir \
      httpx backoff requests-cache \
      geoip2 maxminddb \
      prometheus-client \
      discord-webhook

RUN useradd -m -d /home/container -s /bin/bash container
USER container
ENV USER=container HOME=/home/container \
    PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
WORKDIR /home/container

COPY --chown=container:container entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r$//' /entrypoint.sh && chmod +x /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
