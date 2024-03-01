# syntax=docker/dockerfile:1.6@sha256:ac85f380a63b13dfcefa89046420e1781752bab202122f8f50032edf31be0021
FROM pscale.dev/wolfi-prod/git:2.44.0@sha256:0f66db74c1d151485da019d2b9c3a2a8b945085b8908773e7655d1ca602b6cb1

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
