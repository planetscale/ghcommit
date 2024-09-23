# syntax=docker/dockerfile:1.10@sha256:865e5dd094beca432e8c0a1d5e1c465db5f998dca4e439981029b3b81fb39ed5
FROM pscale.dev/wolfi-prod/git:2.46.1@sha256:b14137a2f7f25d2b4baccbe12d0f06454d3e80ef6f168265b4fc5e7f7fee3dbe

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
