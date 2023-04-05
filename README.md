# ghcommit

Use GitHub's GraphQL API's `createCommitOnBranch` mutation to commit files to a GitHub repository.

## Why?

Enable keyless signing.

Commits made within a CI environment like GitHub Actions using the `git` cli line will not
be signed. By using the API, commits are signed with GitHub's GPG key.

This method allows for signed commits in a CI environment without needing to manage private
GPG keys. This is important for repositories that require signed commits as part of their
branch protection.

It is possible to sign commits with GPG, however managing GPG keys can be cumbersome,
especially when maintainers leave a project. Using the API eliminates the need for key management.

## Install

TODO

## Usage

TODO

## Alternatives

As mentioned above, it is possible to sign commits with GPG.

Another option which uses a form of keyless signing is the [gitsign](https://github.com/sigstore/gitsign) project.
However, as of April 2023, GitHub does not recognize the signatures created by gitsign and so
these commits will not be identified as "verified" by GitHub.Q