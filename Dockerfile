# syntax=docker/dockerfile:1.4@sha256:9ba7531bd80fb0a858632727cf7a112fbfd19b17e94c4e84ced81e24ef1a0dbc
FROM pscale.dev/wolfi-prod/git:2.43.0@sha256:a49972c4b2e8ebac76187350f23c242c628a63e50df83ad1eb1bb7b04f24f472

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
