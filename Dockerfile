FROM cgr.dev/chainguard/git:2.40.0

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]