# syntax=docker/dockerfile:1.6@sha256:ac85f380a63b13dfcefa89046420e1781752bab202122f8f50032edf31be0021
FROM pscale.dev/wolfi-prod/git:2.43.2@sha256:d10b4ff51f6fce723a04c248f4b18a80560cafe46ee35b6ae96c752ada291ee0

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
