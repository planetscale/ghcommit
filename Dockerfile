# syntax=docker/dockerfile:1.14@sha256:0232be24407cc42c983b9b269b1534a3b98eea312aad9464dd0f1a9e547e15a7
FROM pscale.dev/wolfi-prod/git:2.48.1

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
