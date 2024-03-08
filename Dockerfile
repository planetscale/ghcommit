# syntax=docker/dockerfile:1.7@sha256:dbbd5e059e8a07ff7ea6233b213b36aa516b4c53c645f1817a4dd18b83cbea56
FROM pscale.dev/wolfi-prod/git:2.44.0@sha256:086b2317307b3902b5fcb8be66ba83e499d86a3329255ca27068429ab47bfcb2

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
