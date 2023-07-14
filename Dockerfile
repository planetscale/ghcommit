# syntax=docker/dockerfile:1.4
# cgr.dev/chainguard/git:2.41.0:
FROM cgr.dev/chainguard/git@sha256:df4657d49fb838f3be8b1938c0daf8c40a96461e479f89854ee8b9def93addff

COPY ghcommit /ghcommit

ENTRYPOINT ["/ghcommit"]
