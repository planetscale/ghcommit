# syntax=docker/dockerfile:1.7@sha256:dbbd5e059e8a07ff7ea6233b213b36aa516b4c53c645f1817a4dd18b83cbea56
FROM pscale.dev/wolfi-prod/git:2.44.0@sha256:4b9e354aa4a967fef99d7b1918d138b07f64473e619bb8bb583497c0fff00887

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
