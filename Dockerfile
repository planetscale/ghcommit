FROM cgr.dev/chainguard/git:2.41.0

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]