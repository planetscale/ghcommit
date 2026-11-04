# syntax=docker/dockerfile:1.28@sha256:bb22d9815c728170f72750f4e5b0d672e06176142e1d602c7e66c050100b7e5b
FROM pscale.dev/wolfi-prod/git:2.56.0

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
