ARG postgres_version=12

FROM postgres:$postgres_version

ENV PLV8_VERSION=2.3.14 \
    PLV8_SHASUM="9bfbe6498fcc7b8554e4b7f7e48c75acef10f07cf1e992af876a71e4dbfda0a6"


RUN buildDependencies="build-essential \
    ca-certificates \
    curl \
	wget \
	lsb-release \
    git-core \
    python \
    gpp \
    cpp \
    pkg-config \
    apt-transport-https \
    cmake \
    libc++-dev \
    libc++abi-dev \
    postgresql-server-dev-$PG_MAJOR" \
  && runtimeDependencies="libc++1 \
    libtinfo5 \
    libc++abi1" \
  && apt-get update \
  && apt-get upgrade \
  && apt-get install -y --no-install-recommends ${buildDependencies} ${runtimeDependencies} \
  && sh -c "echo 'deb https://packagecloud.io/timescale/timescaledb/debian/ `lsb_release -c -s` main' > /etc/apt/sources.list.d/timescaledb.list" \
  && wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | apt-key add - \
  && apt-get update \
  && apt-get install -y timescaledb-postgresql-12 \
  && timescaledb-tune --quiet --yes \
  && mkdir -p /tmp/build \
  && curl -o /tmp/build/v$PLV8_VERSION.tar.gz -SL "https://github.com/plv8/plv8/archive/v${PLV8_VERSION}.tar.gz" \
  && cd /tmp/build \
  && echo $PLV8_SHASUM v$PLV8_VERSION.tar.gz | sha256sum -c \
  && tar -xzf /tmp/build/v$PLV8_VERSION.tar.gz -C /tmp/build/ \
  && cd /tmp/build/plv8-$PLV8_VERSION \
  && make static \
  && make install \
  && strip /usr/lib/postgresql/${PG_MAJOR}/lib/plv8-${PLV8_VERSION}.so \
  && rm -rf /root/.vpython_cipd_cache /root/.vpython-root \
  && apt-get clean \
  && apt-get remove -y ${buildDependencies} \
  && apt-get autoremove -y \
  && rm -rf /tmp/build /var/lib/apt/lists/* /tmp/*.zip

COPY docker-entrypoint-initdb.d/* /docker-entrypoint-initdb.d/


USER postgres

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]