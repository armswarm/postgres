FROM armhf/alpine:latest

LABEL repository="https://github.com/armswarm/postgres"

ARG PG_VERSION

ENV LANG=en_US.utf8 \
    GOSU_VERSION=1.9-r0 \
    PG_VERSION=${PG_VERSION} \
    PGDATA=/var/lib/postgresql/data \
    PGRUN=/var/run/postgresql

RUN mkdir -p ${PGRUN} \
    && chown -R postgres ${PGRUN} \
    && mkdir /docker-entrypoint-initdb.d

RUN apk add --no-cache --upgrade -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    bash \
    gosu=${GOSU_VERSION} \
    postgresql=${PG_VERSION} \
    postgresql-contrib=${PG_VERSION}

COPY docker-entrypoint.sh /

VOLUME ${PGDATA}

EXPOSE 5432

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["postgres"]
