# syntax=docker/dockerfile:1.4
# cgr.dev/chainguard/git:2.41.0:
FROM cgr.dev/chainguard/git@sha256:b307b49ca172455aa5f9ba3693c1972c7a29e7bff8425a5b7bd63a0ca0f94850

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
