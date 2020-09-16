FROM golang:1.15.0-alpine3.12 AS sql-migrate-build

RUN set -ex && \
  apk add --no-cache --virtual .installer git build-base && \
  go get -v github.com/rubenv/sql-migrate/... && \
  mkdir -p /build && \
  cp -rf /go/bin/sql-migrate /build/sql-migrate

######################
FROM alpine:3.12 AS runtime

WORKDIR /workspace
COPY --from=sql-migrate-build /build/sql-migrate /usr/local/bin/sql-migrate
CMD ["sql-migrate"]
