# syntax=docker/dockerfile:1.10@sha256:865e5dd094beca432e8c0a1d5e1c465db5f998dca4e439981029b3b81fb39ed5
FROM pscale.dev/wolfi-prod/git:2.46.0@sha256:d02c5f6a17bbf4269577962d9acbed45e818acb524661ea9accb7c3c2198dfe5

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
