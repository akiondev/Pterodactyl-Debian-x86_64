# syntax=docker/dockerfile:1.6
FROM debian:bookworm-slim

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      bash ca-certificates curl unzip file tzdata tar openssl sed \
      python3 python3-pip python3-venv \
      libmaxminddb0 libmaxminddb-dev mmdb-bin \
      build-essential python3-dev gcc \
      libffi-dev libssl-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

RUN python3 -m pip install --upgrade pip setuptools wheel \
 && python3 -m pip install --no-cache-dir --prefer-binary \
      httpx==0.27.0 \
      backoff==2.2.1 \
      requests-cache==1.2.0 \
      maxminddb==2.6.2 \
      geoip2==4.8.0 \
      prometheus-client==0.20.0 \
      discord-webhook==1.3.1

COPY entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r$//' /entrypoint.sh && chmod +x /entrypoint.sh

RUN useradd -m -d /home/container -s /bin/bash container \
 && chown container:container /entrypoint.sh

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

CMD ["/bin/bash", "/entrypoint.sh"]
