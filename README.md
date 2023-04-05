# ghcommit

Commit a file to a GitHub repository using the GraphQL API's `createCommitOnBranch` mutation.

## Why?

Keyless signing.

Committing changes from inside a CI environment such as GitHub Actions
using the `git` cli will not create signed commits. However, commits made through
the API are signed by GitHub's own GPG key.

This provides a simple way to commit changes to a repository from inside a CI
environment and have the commit signed by GitHub. This is critical for repositories
that have enabled the `enforce signed commits` branch protection option.

You could simply sign with GPG keys by putting a private GPG key into the CI environment.
However, then you need a way to manage these keys and rotate them as maintainers
leave the project, because they could have a copy of the GPG key. By committing via the API
you avoid the overhead of managing GPG keys.

## Install

TODO

## Usage

TODO