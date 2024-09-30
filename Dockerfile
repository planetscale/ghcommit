# syntax=docker/dockerfile:1.10@sha256:865e5dd094beca432e8c0a1d5e1c465db5f998dca4e439981029b3b81fb39ed5
FROM pscale.dev/wolfi-prod/git:2.46.2@sha256:03a446b81e86a142c1066fbdb58f2f1f07388ab23c99a44b7773b7eb7f27693d

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
