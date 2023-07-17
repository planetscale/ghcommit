# syntax=docker/dockerfile:1.4
# cgr.dev/chainguard/git:2.41.0:
FROM cgr.dev/chainguard/git@sha256:5f6ba81dbdd3984a9c2195358ee9b2fe59a41b78273e4c4ae2afa2101d425a3c

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
