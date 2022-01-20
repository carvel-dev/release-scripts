#!/bin/bash

set -e -x -u

go build -trimpath -o "helloWorld${IMGPKG_BINARY_EXT-}" ./hello_world.go

echo "Success"
