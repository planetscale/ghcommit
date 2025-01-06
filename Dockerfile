# syntax=docker/dockerfile:1.12@sha256:93bfd3b68c109427185cd78b4779fc82b484b0b7618e36d0f104d4d801e66d25
FROM pscale.dev/wolfi-prod/git:2.47.1

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
