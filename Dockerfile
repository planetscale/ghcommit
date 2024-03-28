# syntax=docker/dockerfile:1.7@sha256:dbbd5e059e8a07ff7ea6233b213b36aa516b4c53c645f1817a4dd18b83cbea56
FROM pscale.dev/wolfi-prod/git:2.44.0@sha256:e9699e0bb9b2a071af3f3815b2ad08263785819c427e9ca627865b7fa5ef0555

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
