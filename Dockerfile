# syntax=docker/dockerfile:1.15@sha256:05e0ad437efefcf144bfbf9d7f728c17818408e6d01432d9e264ef958bbd52f3
FROM pscale.dev/wolfi-prod/git:2.49.0

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
