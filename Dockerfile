# syntax=docker/dockerfile:1.29@sha256:572cebbc2b15e6f84c077742952674889cb63cd5e9b80abdffcbe587b6f19183
FROM pscale.dev/wolfi-prod/git:2.56.1

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
