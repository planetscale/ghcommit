# syntax=docker/dockerfile:1.4
# cgr.dev/chainguard/git:2.41.0:
FROM cgr.dev/chainguard/git@sha256:fea4b8f37c91aac85d06c69cd8e406f81890f7e841b2d10a84b2cfb1b9ec21c0

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
