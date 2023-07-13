# syntax=docker/dockerfile:1.4
# cgr.dev/chainguard/git:2.41.0:
FROM cgr.dev/chainguard/git@sha256:94e49364bb53f511ee137c21ff1f1355d12f0f03d2fac5540a21b98295781c82

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
