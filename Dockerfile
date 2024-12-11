# syntax=docker/dockerfile:1.12@sha256:db1ff77fb637a5955317c7a3a62540196396d565f3dd5742e76dddbb6d75c4c5
FROM pscale.dev/wolfi-prod/git:2.47.1

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
