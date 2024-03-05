![ci](https://github.com/tcurdt/release-go/workflows/ci/badge.svg?branch=master)

A simple yet sane github action setup for go projects.
It builds and runs test for all selected platforms.
When a tag gets pushed it creates the github release and pushes an image to dockerhub.

# Local Dry Run

```
goreleaser release --skip=publish --skip=validate --clean
```

# Secrets

The following secrets need to be set for the repository:

- DOCKERHUB_USERNAME
- DOCKERHUB_TOKEN
- PAT (to publish to the homebrew tap)

# NixOS

```
nix flake update release-go
```