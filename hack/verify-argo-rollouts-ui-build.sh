#!/bin/bash

SCRIPTPATH="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit
  pwd -P
)"

REPO_ROOT="$SCRIPTPATH/.."
UI_BUILD_DIR="$REPO_ROOT/argo-rollouts-ui-builds"
ARGO_ROLLOUTS_DIR="$REPO_ROOT/argo-rollouts"
CONTAINERFILE="$REPO_ROOT/Containerfile.plugin"

set -e

#1: Get the current commit ID of the argo-rollouts submodule
SUBMODULE_COMMIT=$(git -C $ARGO_ROLLOUTS_DIR rev-parse HEAD)
echo "Argo Rollouts Submodule Commit: $SUBMODULE_COMMIT"

#2: Check if a corresponding UI build exists
if [ ! -d "$UI_BUILD_DIR/$SUBMODULE_COMMIT" ]; then
  echo "Error: No UI build found for submodule commit $SUBMODULE_COMMIT in $UI_BUILD_DIR."
  exit 1
fi
echo "UI build exists for submodule commit $SUBMODULE_COMMIT."

#3: Verify that Containerfile.plugin references the correct commit
if ! grep -q "COPY argo-rollouts-ui-builds/$SUBMODULE_COMMIT/app" "$CONTAINERFILE"; then
  echo "Error: Containerfile.plugin does not reference the correct commit ID ($SUBMODULE_COMMIT)."
  exit 1
fi
echo "Containerfile.plugin file is up to date."

echo "Verification successful: UI build and Containerfile.plugin are in sync with the submodule."
exit 0
