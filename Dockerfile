# syntax=docker/dockerfile:1.27@sha256:bde3983e9c939224420ddaf6b784cc30e09b035a4dea01f581230c50809f372e
FROM pscale.dev/wolfi-prod/git:2.55.0

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
