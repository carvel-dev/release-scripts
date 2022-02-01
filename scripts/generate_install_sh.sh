#!/bin/bash

set -xeu

ytt --data-values-file releases.yaml -f scripts/install_sh/install.sh.txt --output-files tmp

cat tmp/install.sh.txt
