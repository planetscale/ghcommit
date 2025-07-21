# syntax=docker/dockerfile:1.17@sha256:38387523653efa0039f8e1c89bb74a30504e76ee9f565e25c9a09841f9427b05
FROM pscale.dev/wolfi-prod/git:2.50.1

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
