FROM quay.io/armswarm/alpine:3.5

ARG PG_PACKAGE

ENV LANG=en_US.utf8 \
    PG_VERSION="${PG_PACKAGE%-*}" \
    PG_MAJOR="${PG_PACKAGE%.?-*}" \
    PGDATA=/var/lib/postgresql/data

COPY docker-entrypoint.sh /usr/local/bin

RUN \
  mkdir /docker-entrypoint-initdb.d \
  && apk add --no-cache --upgrade \
        ca-certificates \
        bash \
        su-exec \
        postgresql=${PG_PACKAGE} \
        postgresql-contrib=${PG_PACKAGE} \
        tzdata \
  && sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" /usr/share/postgresql/postgresql.conf.sample \
  && mkdir -p /var/run/postgresql \
  && chown -R postgres:postgres /var/run/postgresql \
  && chmod 2777 /var/run/postgresql \
  && mkdir -p "$PGDATA" \
  && chown -R postgres:postgres "$PGDATA" \
  # this 777 will be replaced by 700 at runtime (allows semi-arbitrary "--user" values)
  && chmod 777 "$PGDATA"

VOLUME ${PGDATA}

EXPOSE 5432

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]

CMD [ "postgres" ]
