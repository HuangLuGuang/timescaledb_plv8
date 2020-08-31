ARG postgres_version=12

FROM timescale/timescaledb:$postgres_version

ENV PLV8_VERSION=2.3.14 \
    PLV8_SHASUM="9bfbe6498fcc7b8554e4b7f7e48c75acef10f07cf1e992af876a71e4dbfda0a6"


RUN apk update \
	&& apk add curl git make cmake gcc g++ \
	&& mkdir -p /tmp/build \
	&& curl -o /tmp/build/${PLV8_VERSION}.tar.gz -SL "https://codeload.github.com/plv8/plv8/tar.gz/v${PLV8_VERSION}" \
	&& echo ${PLV8_SHASUM} | sha256sum -c \
	&& tar -xzf /tmp/build/${PLV8_VERSION}.tar.gz -C /tmp/build/ \
	&& cd /tmp/build/plv8-${PLV8_VERSION#?} \
	&& make \
	&& make install \
	&& strip /usr/lib/postgresql/${PG_MAJOR}/lib/plv8-${PLV8_VERSION#?}.so \
	&& rm -rf /tmp/build


