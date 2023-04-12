#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NC=$(tput sgr0)

testAssertionOK() {
  local funcName=${FUNCNAME[1]}
  local result=$1
  local message=$2

  if $result; then
    echo "$funcName": "$GREEN"SUCCESS"$NC"
  else
    exit_if_error 1 "$RED $funcName - FAIL:$NC $message"
  fi
}

testAssertionNotOK() {
  local funcName=${FUNCNAME[1]}
  local result=$1
  local message=$2

  if $result; then
    echo "$funcName": "$GREEN"SUCCESS"$NC"
  else
    exit_if_error 1 "$funcName - FAIL: $message"
  fi
}

exit_if_error() {
  local exit_code=$1
  shift
  [[ $exit_code ]] &&
    ((exit_code != 0)) && {
    printf 'ERROR: %s\n' "$@" >&2
    exit "$exit_code"
  }
}
