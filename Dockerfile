# syntax=docker/dockerfile:1.6@sha256:ac85f380a63b13dfcefa89046420e1781752bab202122f8f50032edf31be0021
FROM pscale.dev/wolfi-prod/git:2.43.0@sha256:a49972c4b2e8ebac76187350f23c242c628a63e50df83ad1eb1bb7b04f24f472

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
