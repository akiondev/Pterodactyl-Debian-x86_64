# syntax=docker/dockerfile:1.6
FROM debian:bookworm-slim

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      bash ca-certificates curl unzip file tzdata tar openssl sed \
      python3 python3-pip python3-venv \
      libmaxminddb0 libmaxminddb-dev mmdb-bin \
      python3-httpx python3-backoff python3-requests-cache \
      python3-geoip2 python3-maxminddb python3-prometheus-client \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

RUN python3 -m pip install --no-cache-dir --prefer-binary discord-webhook==1.3.1

COPY entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r$//' /entrypoint.sh && chmod +x /entrypoint.sh

RUN useradd -m -d /home/container -s /bin/bash container \
 && chown container:container /entrypoint.sh

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

CMD ["/bin/bash", "/entrypoint.sh"]
