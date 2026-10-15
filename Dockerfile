# syntax=docker/dockerfile:1.27@sha256:4edf897a3ffa55b89f906fc8cc78afdb3f1834cc9c7083565e611a8a7d5fe99e
FROM pscale.dev/wolfi-prod/git:2.56.0

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
