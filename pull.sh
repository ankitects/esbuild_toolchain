#!/bin/bash
#
# Grab latest sources ../rules_nodejs checkout
#

rsync -ai ../rules_nodejs/packages/esbuild/{esbuild.bzl,esbuild_repo.bzl,helpers.bzl,launcher.js} .
git add *.bzl
commit=$(cd ../rules_nodejs && git rev-parse HEAD)
git commit -m "update to ${commit}"

