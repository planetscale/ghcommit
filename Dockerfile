# syntax=docker/dockerfile:1.6@sha256:ac85f380a63b13dfcefa89046420e1781752bab202122f8f50032edf31be0021
FROM pscale.dev/wolfi-prod/git:2.43.0@sha256:8ec00255cf9cc3a8efd67a0ee8459ab76f88c69ae2ef1598d612e25430fa94bc

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
