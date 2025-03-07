# syntax=docker/dockerfile:1.14@sha256:4c68376a702446fc3c79af22de146a148bc3367e73c25a5803d453b6b3f722fb
FROM pscale.dev/wolfi-prod/git:2.48.1

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
