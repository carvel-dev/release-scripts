#!/bin/bash

set -xeu


ytt -f ./tmp/release.yml -f releases.yaml -f scripts/releases/overlay.yaml > ./tmp/releases.yml

cat ./tmp/releases.yml
