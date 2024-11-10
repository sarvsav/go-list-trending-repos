#!/bin/bash

set -eo pipefail

# Check if the current commit has a tag
tag=$(git describe --exact-match --tags 2>/dev/null || true)

if [ -n "$tag" ]; then
  # Current commit is tagged, so print the tag
  ldflags=" -X github.com/sarvsav/go-list-trending-repos/version.tag=$tag "
else
  # No exact tag on this commit; get the latest tag and the current commit hash
  last_tag=$(git describe --tags --abbrev=0)
  commit_hash=$(git rev-parse --short HEAD)
  ldflags=" -X github.com/sarvsav/go-list-trending-repos/version.tag=$last_tag-$commit_hash "
fi

# Add commit hash and date information
ldflags+=$(git show -s --format=' -X github.com/sarvsav/go-list-trending-repos/version.commit=%H -X github.com/sarvsav/go-list-trending-repos/version.date=%ct')

# Check for dirty state
git diff --quiet HEAD || ldflags+=" -X github.com/sarvsav/go-list-trending-repos/version.dirty=dirty"

# Output the flags
echo "$ldflags"
