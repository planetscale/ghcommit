# syntax=docker/dockerfile:1.4
# cgr.dev/chainguard/git:2.41.0:
FROM cgr.dev/chainguard/git@sha256:496ee72354d5976856cb371d04fa693abac3cff8fe0429fc477cfa3d4ea5676a

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
