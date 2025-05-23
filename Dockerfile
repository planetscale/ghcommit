# syntax=docker/dockerfile:1.16@sha256:e2dd261f92e4b763d789984f6eab84be66ab4f5f08052316d8eb8f173593acf7
FROM pscale.dev/wolfi-prod/git:2.49.0

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
