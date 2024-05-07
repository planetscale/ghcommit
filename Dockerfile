# syntax=docker/dockerfile:1.7@sha256:a57df69d0ea827fb7266491f2813635de6f17269be881f696fbfdf2d83dda33e
FROM pscale.dev/wolfi-prod/git:2.45.0@sha256:4715a72888cf4a361d89db7dc0265e62744ee556a23f27cc6c59fba669dde9a6

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
