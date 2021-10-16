#!/bin/bash

set -xeu

product=${1}
product_dir=./releases/${product}/

path_to_install_sh=${2}

latest_release_file=$(ls ${product_dir} | sort --version-sort --reverse | head -n1)
previous_release_file=$(ls ${product_dir} | sort --version-sort --reverse | head -n2 | tail -n1)

ytt \
  -f $path_to_install_sh \
  -f ./scripts/install_sh/install_sh_schema.yml \
  -f ./scripts/install_sh/install_sh.yml \
  -f ${product_dir}/${latest_release_file}  \
  --data-values-file <(ytt -f ${product_dir}/$previous_release_file -f ./scripts/install_sh/previous_release_dv.yml) \
  -v product=${product} \
  -o json | jq -r .output