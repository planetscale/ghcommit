# syntax=docker/dockerfile:1.6@sha256:ac85f380a63b13dfcefa89046420e1781752bab202122f8f50032edf31be0021
FROM pscale.dev/wolfi-prod/git:2.43.0@sha256:11fdd8778cde229706e7e16c2fe77f4d86fd64bf71da7780d817fdd6b619a578

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
