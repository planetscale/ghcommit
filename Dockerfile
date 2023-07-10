# syntax=docker/dockerfile:1.4
# cgr.dev/chainguard/git:2.41.0:
FROM cgr.dev/chainguard/git@sha256:ae4964853d7eea26838000d9e40f5113255b4cbb7b8a6fd12470609fb3e9ea7f

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
