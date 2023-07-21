# syntax=docker/dockerfile:1.4
# cgr.dev/chainguard/git:2.41.0:
FROM cgr.dev/chainguard/git@sha256:502e70c2ec742b148e626a6b586d177da31b597fbd25c6d21ed51a1f50c1925f

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
