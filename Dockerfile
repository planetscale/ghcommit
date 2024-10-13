# syntax=docker/dockerfile:1.10@sha256:865e5dd094beca432e8c0a1d5e1c465db5f998dca4e439981029b3b81fb39ed5
FROM pscale.dev/wolfi-prod/git:2.47.0@sha256:2879d75fa7e6ecf2ae3fded550224cce20a1e408aafad2328c7644c5380d9f45

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
