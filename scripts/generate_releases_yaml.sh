#!/bin/bash

set -xeu

releaseFile=$1
ytt -f $releaseFile -f releases.yaml -f scripts/releases/overlay.yaml > ./tmp/releases.yml

cat ./tmp/releases.yml
