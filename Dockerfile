FROM cgr.dev/chainguard/git:2.40.1

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]