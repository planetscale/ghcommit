# syntax=docker/dockerfile:1.19@sha256:b6afd42430b15f2d2a4c5a02b919e98a525b785b1aaff16747d2f623364e39b6
FROM pscale.dev/wolfi-prod/git:2.51.0

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
