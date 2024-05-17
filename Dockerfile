# syntax=docker/dockerfile:1.7@sha256:a57df69d0ea827fb7266491f2813635de6f17269be881f696fbfdf2d83dda33e
FROM pscale.dev/wolfi-prod/git:2.45.1@sha256:7eb398437c23eae3df0e9184d16a637252abe2bf18f0972d16350c7820b4d3c1

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
