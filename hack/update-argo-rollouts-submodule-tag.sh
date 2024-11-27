#!/bin/bash

if [ "$#" -lt 1 ]; then
	echo "* Error: requires 1 argument"
    echo "Usage: $0 \"(... target argo-rollouts tag/commit ...)\"" >&2
    exit 1
fi

TARGET_COMMIT=$1
SCRIPTPATH="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit
  pwd -P
)"

REPO_ROOT="$SCRIPTPATH/.."
UI_BUILD_DIR="argo-rollouts-ui-builds"
ARGO_ROLLOUTS_DIR="argo-rollouts"
CONTAINERFILE="$REPO_ROOT/Containerfile.plugin"

set -e

cd $REPO_ROOT

#1: Update submodule
echo "Updating argo-rollouts submodule to $TARGET_COMMIT..."
git submodule update --init --recursive
git -C $ARGO_ROLLOUTS_DIR fetch --tags
git -C $ARGO_ROLLOUTS_DIR checkout $TARGET_COMMIT

#2: Clear argo-rollouts-ui directory
echo "Clearing argo-rollouts-ui directory..."
rm -rf "$REPO_PATH/argo-rollouts-ui-builds/*"

#3: Build argo-rollouts UI
echo "Building argo-rollouts UI..."
cd $ARGO_ROLLOUTS_DIR/ui
yarn install
yarn build
cd $REPO_ROOT

#4: Copy build to argo-rollouts-ui-builds
COMMIT_ID=$(git -C $ARGO_ROLLOUTS_DIR rev-parse HEAD)
echo "Copying build to $UI_BUILD_DIR/$COMMIT_ID..."
mkdir -p $UI_BUILD_DIR/$COMMIT_ID
cp -r $ARGO_ROLLOUTS_DIR/ui/dist/* $UI_BUILD_DIR/$COMMIT_ID/

#5: Update Containerfile.plugin
echo "Updating $CONTAINERFILE with new commit ID..."
# Compatible sed command for both macOS and Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' "s|COPY argo-rollouts-ui-builds/.*|COPY argo-rollouts-ui-builds/$COMMIT_ID/app argo-rollouts/ui/dist/app|" $CONTAINERFILE
else
  sed -i "s|COPY argo-rollouts-ui-builds/.*|COPY argo-rollouts-ui-builds/$COMMIT_ID/app argo-rollouts/ui/dist/app|" $CONTAINERFILE
fi

#6: Stage changes
echo "Staging changes..."
git add $ARGO_ROLLOUTS_DIR
git add $UI_BUILD_DIR/$COMMIT_ID
git add $CONTAINERFILE

echo "Done. Commit and push the changes:"
echo "git commit -m \"Update argo-rollouts submodule and UI build to $TARGET_COMMIT\""
echo "git push"
