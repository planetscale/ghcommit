# syntax=docker/dockerfile:1.7@sha256:a57df69d0ea827fb7266491f2813635de6f17269be881f696fbfdf2d83dda33e
FROM pscale.dev/wolfi-prod/git:2.44.0@sha256:713af3be1b94865d3c914786fe999ec1e78354a4b1410520a78a72ed78f29c8e

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
