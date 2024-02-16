# syntax=docker/dockerfile:1.6@sha256:ac85f380a63b13dfcefa89046420e1781752bab202122f8f50032edf31be0021
FROM pscale.dev/wolfi-prod/git:2.43.2@sha256:1be4e84c60e1c52a0c1e348a0a2aa762fbe3a00fe37891204d792653eb30919f

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
