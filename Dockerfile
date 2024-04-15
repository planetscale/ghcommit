# syntax=docker/dockerfile:1.7@sha256:dbbd5e059e8a07ff7ea6233b213b36aa516b4c53c645f1817a4dd18b83cbea56
FROM pscale.dev/wolfi-prod/git:2.44.0@sha256:eac1665f87f617fd13a6e3085f22b957911234df2ce97082269b500d2c75437b

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
