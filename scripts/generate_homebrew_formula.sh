#!/bin/bash

set -xeu

ytt -f ./scripts/homebrew_formula.yml -f ./releases/imgpkg/0.17.0.yml  -o json | jq -r .homebrew_formula_template