# syntax=docker/dockerfile:1.7@sha256:a57df69d0ea827fb7266491f2813635de6f17269be881f696fbfdf2d83dda33e
FROM pscale.dev/wolfi-prod/git:2.45.1@sha256:e3860361253aec0410ab447be3cbce5ddd085e87683705b9e7484e90cbe86700

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
