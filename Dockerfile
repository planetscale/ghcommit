# syntax=docker/dockerfile:1.7@sha256:a57df69d0ea827fb7266491f2813635de6f17269be881f696fbfdf2d83dda33e
FROM pscale.dev/wolfi-prod/git:2.45.2@sha256:224e05cf95130f1d02678410041679028c230e3846544d1da4163a53ad78c5b7

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
