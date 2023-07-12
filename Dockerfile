# syntax=docker/dockerfile:1.4
# cgr.dev/chainguard/git:2.41.0:
FROM cgr.dev/chainguard/git@sha256:c498617cc6fd52c2578d7076dadaa15337e9a100fe0a35a8ffb1255c49fb35f5

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
