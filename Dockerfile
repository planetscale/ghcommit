# syntax=docker/dockerfile:1.7@sha256:a57df69d0ea827fb7266491f2813635de6f17269be881f696fbfdf2d83dda33e
FROM pscale.dev/wolfi-prod/git:2.45.0@sha256:dc8cdecad4533dfc533804232912a9a4cc76c671e70eb8d704b00891fad46f2c

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
