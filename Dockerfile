# syntax=docker/dockerfile:1.6@sha256:ac85f380a63b13dfcefa89046420e1781752bab202122f8f50032edf31be0021
FROM pscale.dev/wolfi-prod/git:2.43.0@sha256:d782f3199b3cd538af44c47a4157a0a6be665f62922f5016024309f471066bfe

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
