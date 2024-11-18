#!/bin/bash

if [ "$#" -lt 1 ]; then
	echo "* Error: requires 1 argument"
    echo "Usage: $0 \"(... target argo-rollouts tag ...)\"" >&2
    exit 1
fi

SCRIPTPATH="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit
  pwd -P
)"

set -e

REPO_ROOT="$SCRIPTPATH/.."

cd $REPO_ROOT

git submodule update --init --recursive

git -C argo-rollouts checkout tags/$1
git add argo-rollouts

echo Next, commit and push:
echo git commit -m "Update submodule to tag $1"
echo git push

