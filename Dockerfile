# syntax=docker/dockerfile:1.4
# cgr.dev/chainguard/git:2.41.0:
FROM cgr.dev/chainguard/git@sha256:115264e4bb7844ed0635a51630b9fbfb507e3292d8542bf27ed4613642059995

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
