# syntax=docker/dockerfile:1.6@sha256:ac85f380a63b13dfcefa89046420e1781752bab202122f8f50032edf31be0021
FROM pscale.dev/wolfi-prod/git:2.43.0@sha256:6467677954421074db29a35b762358ca6b44e4be4991895ffe5f6816a6bd9efd

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
