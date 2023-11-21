# syntax=docker/dockerfile:1.4
FROM pscale.dev/wolfi-prod/git:2.43.0

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
