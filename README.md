# ghcommit

Use GitHub's GraphQL API `createCommitOnBranch` mutation to commit files to a GitHub repository.

There is a companion GitHub Action in the the [ghcommit-action](https://github.com/planetscale/ghcommit-action) repo.

## Why?

Enable keyless signing in CI environments. Especially useful for repos which require signed commits and have
CI worklows that commit back to the repo (eg: code formatters, generators, etc).

Normally in order to sign commits from within a CI pipeline you would need to setup and manage GPG or SSH keys
in the CI pipeline. And you take on the risk of those keys be copied by developers with access to the CI environment.
The keys will need to be rotated as people leave the team or keys expire. Using `ghcommit` instead uses the GitHub
GraphQL API to make git commits which are signed by GitHub's web flow GPG key.

> :warning: This is meant for use in CI environments and with small commits. For example, a CI workflow
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
