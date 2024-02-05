# syntax=docker/dockerfile:1.6@sha256:ac85f380a63b13dfcefa89046420e1781752bab202122f8f50032edf31be0021
FROM pscale.dev/wolfi-prod/git:2.43.0@sha256:7e9ec275dff2d98a9388443d4b939b1a3434501b9584427ec46a21c1886c193d

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
