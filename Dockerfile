# syntax=docker/dockerfile:1.7@sha256:a57df69d0ea827fb7266491f2813635de6f17269be881f696fbfdf2d83dda33e
FROM pscale.dev/wolfi-prod/git:2.45.2@sha256:03cef6284e997316bbecd524e24a818b2c2de2b6f51d514a6b3817e5a9141c08

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
