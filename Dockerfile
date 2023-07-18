# syntax=docker/dockerfile:1.4
# cgr.dev/chainguard/git:2.41.0:
FROM cgr.dev/chainguard/git@sha256:523a38daa32e21ed22c131e0268a9a88c7776853d05a2bc037fe04bc562fb398

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
