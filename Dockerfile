FROM cgr.dev/chainguard/git@sha256:549b8c78695131d41018e12e1c21107322227fd0669126f4bf13d00bf64cac6c # 2.41.0

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
