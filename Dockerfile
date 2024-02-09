# syntax=docker/dockerfile:1.6@sha256:ac85f380a63b13dfcefa89046420e1781752bab202122f8f50032edf31be0021
FROM pscale.dev/wolfi-prod/git:2.43.0@sha256:3bb9fe8f83d8a27261a9c6c3b93550d23a078ab4361d72bb6fd58240c60007ae

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
