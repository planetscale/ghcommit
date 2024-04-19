# syntax=docker/dockerfile:1.7@sha256:dbbd5e059e8a07ff7ea6233b213b36aa516b4c53c645f1817a4dd18b83cbea56
FROM pscale.dev/wolfi-prod/git:2.44.0@sha256:fc09a064116357822d5e43cf306374b7c91b64bc3714b042934494396298016c

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
