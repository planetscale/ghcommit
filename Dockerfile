# syntax=docker/dockerfile:1.13@sha256:426b85b823c113372f766a963f68cfd9cd4878e1bcc0fda58779127ee98a28eb
FROM pscale.dev/wolfi-prod/git:2.48.1

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
