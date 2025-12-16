# syntax=docker/dockerfile:1.20@sha256:26147acbda4f14c5add9946e2fd2ed543fc402884fd75146bd342a7f6271dc1d
FROM pscale.dev/wolfi-prod/git:2.52.0

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
