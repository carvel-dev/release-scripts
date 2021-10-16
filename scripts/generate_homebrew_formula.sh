#!/bin/bash

set -xeu

product=${1}
product_dir=./releases/${product}/

latest_release_file=$(ls ${product_dir} | sort --version-sort --reverse | head -n1)

ytt \
  -f ./scripts/homebrew_formula_schema.yml \
  -f ./scripts/homebrew_formula.yml \
  -f ${product_dir}/${latest_release_file}  \
  -v product=${product} \
  -o json | jq -r .output