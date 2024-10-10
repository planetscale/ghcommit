# syntax=docker/dockerfile:1.10@sha256:865e5dd094beca432e8c0a1d5e1c465db5f998dca4e439981029b3b81fb39ed5
FROM pscale.dev/wolfi-prod/git:2.47.0@sha256:c02b69ada713968f4c26714b38ac77c4f2bd4883ef17c5929febe2924181ac6d

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
