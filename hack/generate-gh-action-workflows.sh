#!/bin/bash
set -eu

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
product=$1

ytt -f ${SCRIPT_DIR}/schema.yml -f ${SCRIPT_DIR}/dist.yml --data-value product=${product} > ${SCRIPT_DIR}/../.github/workflows/dist_${product}.yml