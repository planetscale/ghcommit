# syntax=docker/dockerfile:1.4
FROM us-docker.pkg.dev/planetscale-registry/wolfi-prod/git:2.41.0

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
