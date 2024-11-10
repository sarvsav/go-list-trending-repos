#!/bin/bash

set -eo pipefail
git show -s --format='-X github.com/sarvsav/go-list-trending-repos/version.commit=%H -X github.com/sarvsav/go-list-trending-repos/version.date=%ct'
git diff --quiet HEAD || echo '-X github.com/sarvsav/go-list-trending-repos/version.dirty=dirty'