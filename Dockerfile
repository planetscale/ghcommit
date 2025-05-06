# syntax=docker/dockerfile:1.15@sha256:9857836c9ee4268391bb5b09f9f157f3c91bb15821bb77969642813b0d00518d
FROM pscale.dev/wolfi-prod/git:2.49.0

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
