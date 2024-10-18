# syntax=docker/dockerfile:1.10@sha256:865e5dd094beca432e8c0a1d5e1c465db5f998dca4e439981029b3b81fb39ed5
FROM pscale.dev/wolfi-prod/git:2.47.0@sha256:8ff97fe304d4520f1b1f03b5718238562a2188bcb8db369f9eeb09a6dd65b05f

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
