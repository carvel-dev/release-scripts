#!/bin/bash

set -xeu


release_file=${1:-releases.yaml}
output_folder=${2:-tmp/}

ytt --data-values-file "$release_file" -f scripts/install_sh --output-files "$output_folder"
