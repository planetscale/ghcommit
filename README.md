# ghcommit

Use GitHub's GraphQL API `createCommitOnBranch` mutation to commit files to a GitHub repository.

## Why?

Enable keyless signing.

Commits made within a CI environment like GitHub Actions using the `git` cli line will not
be signed. By using the API, commits are signed with GitHub's GPG key.

This method allows for signed commits in a CI environment without needing to manage private
GPG keys. This is important for repositories that require signed commits as part of their
branch protection.

It is possible to sign commits with GPG, however managing GPG keys can be cumbersome,
especially when maintainers leave a project. Using the API eliminates the need for key management.

:warning: This is meant for use in CI environments and with small commits. For example, a CI workflow
that formats code and commits the changes. This is not meant to be used for large commits
and should not be used in place of `git` for day-to-day development.

## Install

1. go install: `go install github.com/planetscale/ghcommit@latest`
2. Binaries, tarballs, and docker images are available on the [github releases](https://github.com/planetscale/ghcommit/releases) page.

## Usage

A `GITHUB_TOKEN` environment variable must be set.

The `-r/--repository`, `-b/--branch`, and `-m/--message` flags are required.

At least one added/changed or deleted file must be specified.

Provide a list of changed/added (`-a/--add`) or deleted (`-d/--delete`) files.  The `-a` and `-d` flags may be used multiple times.

```console
ghcommit -r owner/repo -b branch --add newfile.txt --add changedfile.txt --delete deletedfile.txt
```

All flags may be provided via environment variables. Run `ghcommit -h` to see the full list of flags and env vars.

> NOTE: Changes are not reflected on the local clone of the repository. The commit is made directly to the GitHub repository.
> This utility is meant to be run from CI pipelines where the local clone is ephemeral.

## Alternatives

As mentioned above, it is possible to sign commits with GPG.

Another option which uses a form of keyless signing is the [sigstore/gitsign](https://github.com/sigstore/gitsign)
project.  However, as of April 2023, GitHub does not recognize signatures created by `gitsign` so
these commits will not be identified as "verified" by GitHub.

## Releasing

Releases are generated automatically on all successful `main` branch builds. This project uses
[autotag](https://github.com/pantheon-systems/autotag) and [goreleaser](https://goreleaser.com/) to
automate this process.

Semver (`vMajor.Minor.Patch`) is used for versioning and releases. By default, `autotag` will bump the
patch version on a successful main build, eg: `v1.0.0` -> `v1.0.1`.

To bump the major or minor release instead, include `[major]` or `[minor]` in the commit message.
Refer to the autotag [docs](https://github.com/pantheon-systems/autotag#incrementing-major-and-minor-versions)
for more details.

Include `[skip ci]` in the commit message to prevent a new version from being released. Only use this
for things like documentation updates.