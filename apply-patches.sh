#!/usr/bin/env bash
# Applies patches/*.patch, in order, to the Skiko submodule's working tree. Run it on a clean checkout:
# `git -C skiko checkout -- .` undoes it.
set -euo pipefail
cd "$(dirname "$0")"
for patch in patches/*.patch; do
  git -C skiko apply --verbose "../$patch"
done
