# syntax=docker/dockerfile:1.8@sha256:e87caa74dcb7d46cd820352bfea12591f3dba3ddc4285e19c7dcd13359f7cefd
FROM pscale.dev/wolfi-prod/git:2.45.2@sha256:a06142ab5e57331faf7021b9ba16391192543fc295ea0d4bc2d41d7f7223c8b3

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
