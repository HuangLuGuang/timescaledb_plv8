ARG postgres_version=12

FROM timescale/timescaledb:latest-pg$postgres_version

ENV PLV8_VERSION=2.3.14 \
    PLV8_SHASUM="9bfbe6498fcc7b8554e4b7f7e48c75acef10f07cf1e992af876a71e4dbfda0a6"


RUN  mkdir -p /tmp/build \
  && curl -o /tmp/build/v$PLV8_VERSION.tar.gz -SL "https://github.com/plv8/plv8/archive/v${PLV8_VERSION}.tar.gz" \
  && cd /tmp/build \
  && echo $PLV8_SHASUM v$PLV8_VERSION.tar.gz | sha256sum -c \
  && tar -xzf /tmp/build/v$PLV8_VERSION.tar.gz -C /tmp/build/ \
  && cd /tmp/build/plv8-$PLV8_VERSION \
  && make static \
  && make install \
  && strip /usr/lib/postgresql/${PG_MAJOR}/lib/plv8-${PLV8_VERSION}.so \
  && rm -rf /root/.vpython_cipd_cache /root/.vpython-root \

  && rm -rf /tmp/build

USER postgres

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]
