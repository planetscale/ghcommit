# syntax=docker/dockerfile:1.18@sha256:dabfc0969b935b2080555ace70ee69a5261af8a8f1b4df97b9e7fbcf6722eddf
FROM pscale.dev/wolfi-prod/git:2.51.0

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
