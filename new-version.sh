#!/usr/bin/env bash
# Makes the branch for a Skiko version, skiko-<version>, from main: the submodule at Skiko's tag v<version>, its version
# in skiko-version, and the patches checked against it. Push the branch, then tag a release on it: v<version>-<revision>.
set -euo pipefail
cd "$(dirname "$0")"
version="$1"
git switch --create "skiko-$version" main
git -C skiko fetch --depth 1 origin tag "v$version"
git -C skiko checkout --quiet "v$version"
for patch in patches/*.patch; do
  git -C skiko apply --check "../$patch"
done
echo "$version" > skiko-version
git add skiko skiko-version
git commit --quiet --message "Build Skiko $version"
echo "skiko-$version is ready: git push -u origin skiko-$version && git tag v$version-1 && git push origin v$version-1"
