#!/bin/bash

set -xeu

release_file=${1}

ytt \
  -f ./scripts/homebrew/homebrew_formula_schema.yml \
  -f ./scripts/homebrew/homebrew_formula.yml \
  -f ${release_file}  \
  -o json | jq -r .output
