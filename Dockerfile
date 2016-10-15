FROM armhf/alpine:latest
MAINTAINER armswarm

# metadata params
ARG PROJECT_NAME
ARG BUILD_DATE
ARG VCS_URL
ARG VCS_REF

# metadata
LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$PROJECT_NAME \
      org.label-schema.url=$VCS_URL \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vendor="armswarm" \
      org.label-schema.version="latest"

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
