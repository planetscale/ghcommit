# syntax=docker/dockerfile:1.4
# cgr.dev/chainguard/git:2.41.0:
FROM cgr.dev/chainguard/git@sha256:c363a5b834207d54d3c2e28482f6ff6192d5f20b1e7f7e70db9e39ffb101d48f

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
