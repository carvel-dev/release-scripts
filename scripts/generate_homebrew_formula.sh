#!/bin/bash

set -xeu

product=${1}
product_dir=./releases/${product}/

latest_release_file=$(ls ${product_dir} | sort --version-sort --reverse | head -n1)

ytt -f ./scripts/homebrew_formula.yml -f ${product_dir}/${latest_release_file}  -o json | jq -r .homebrew_formula_template