# Argo Rollouts Source Repository for Konflux builds

The goal of this repository is to provide a public GitHub repository which tracks upstream Argo Rollouts, and which is then supplemented by additional [Konflux](https://konflux-ci.dev) build/release artifacts required for downstream builds.

The [argo-rollouts repository](https://github.com/argoproj/argo-rollouts) is tracked via a sub-module, which should be kept up-to-date with the target of a particular OpenShift GitOps release. The use of Git submodules follows the suggestions provided in the [Konflux documentation](https://konflux-ci.dev/docs/how-tos/workflows/git-submodules/).


# Intial Setup Steps

This repository was initialized with:
```bash
git init
git branch -m main
git submodule add https://github.com/argoproj/argo-rollouts.git

# Finally, manually add '  branch = main' to .gitmodules, as recommended by https://konflux-ci.dev/docs/how-tos/workflows/git-submodules/
```
