#!/bin/bash

set -eu

testDir="./tmp-install-sh"
outputFolder="./tmp-install-sh-output"
source "$(dirname "$0")/assertions.sh"

function cleanup {
  echo "Removing $testDir"
  rm -rf $testDir
  echo "Removing $outputFolder"
  rm -rf $outputFolder
}

trap cleanup EXIT

generateInstallSH() {
    ./scripts/generate_install_sh.sh "$1" "$2"
}

createFileWithContent() {
    mkdir -p $testDir
    cat <<EOF >./$testDir/"$1"
$2
EOF
}

removeTestDirectory() {
    rm -r $testDir
}


TestBasicInstallationScript() {
    createFileWithContent "ytt-release.yml" "
products:
- product: ytt
  version: v0.45.0
  github:
    url: github.com/carvel-dev/ytt
  assets:
  - os: darwin
    arch: amd64
    shasum: c2781a30caf7f573dece6ec186ac0e97470d0de2eccf9fcf63f267c35495ac30
    filename: ytt-darwin-amd64
  - os: darwin
    arch: arm64
    shasum: 3262a49fd8b2e73d8bf5776d9afc16b64c5e0300a842f30acf4d1b6ec080e228
    filename: ytt-darwin-arm64
  - os: linux
    arch: amd64
    shasum: d05f430ac18b3791d831f4cfd78371a7549f225dfaeb6fef2e5bfcd293d6c382
    filename: ytt-linux-amd64
  - os: linux
    arch: arm64
    shasum: 54e228823e851320b848d854218004299d2ff362e0fe9e287d5a52df502baaaf
    filename: ytt-linux-arm64
  - os: windows
    arch: amd64
    shasum: 49a857875a07640dc3a5e522cbc19ef2f9ba74b8c2047848b845b20d0addc4a8
    filename: ytt-windows-amd64.exe
  - os: windows
    arch: arm64
    shasum: e381003ecf167e9a7dadf5a18026511f08a1c5fd9a393ad565650e3c7d444be2
    filename: ytt-windows-arm64.exe"

    generateInstallSH "$testDir/ytt-release.yml" $outputFolder
}

TestAddProtocolAddsTheHTTPSToTheURL() {
    createFileWithContent "assertion.star" "
load(\"@ytt:assert\", \"assert\")
load(\"helpers.star\", \"addProtocol\")

assert.equals(addProtocol(\"github.com/carvel-dev/ytt\"), \"https://github.com/carvel-dev/ytt\")
assert.equals(addProtocol(\"http://github.com/carvel-dev/ytt\"), \"https://github.com/carvel-dev/ytt\")
assert.equals(addProtocol(\"https://github.com/carvel-dev/ytt\"), \"https://github.com/carvel-dev/ytt\")
"
    
    testAssertionOK "ytt -f scripts/install_sh/helpers.star -f ./$testDir/assertion.star" "Expected https to have been added to the file but it was not"
}

TestBasicInstallationScript
TestAddProtocolAddsTheHTTPSToTheURL
