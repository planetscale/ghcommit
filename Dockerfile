# syntax=docker/dockerfile:1.26@sha256:ecfaec9ed6d810b56388c508f4121597bfbba70d41a6dfeee4d8cad5f295fc32
FROM pscale.dev/wolfi-prod/git:2.55.0

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
