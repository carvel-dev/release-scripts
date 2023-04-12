#!/bin/bash

set -eu

testDir="./tmp-install-sh"
outputFolder="./tmp-install-sh-output"
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NC=$(tput sgr0)

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

exit_if_error() {
  local exit_code=$1
  shift
  [[ $exit_code ]] &&               
    ((exit_code != 0)) && {         
      printf 'ERROR: %s\n' "$@" >&2 
      removeTestDirectory
      exit "$exit_code"             
    }
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

    createFileWithContent "expected-result.txt" '
#!/bin/bash
## **This is an autogenerated file, do not change it manually**

if test -z "$BASH_VERSION"; then
  echo "Please run this script using bash, not sh or any other shell." >&2
  exit 1
fi

install() {
  set -euo pipefail

  dst_dir="${K14SIO_INSTALL_BIN_DIR:-/usr/local/bin}"

  if [ -x "$(command -v wget)" ]; then
    dl_bin="wget -nv -O-"
  else
    dl_bin="curl -s -L"
  fi

  shasum -v 1>/dev/null 2>&1 || (echo "Missing shasum binary" && exit 1)

  if [[ `uname` == Darwin ]]; then
    binary_type=darwin-amd64
    
    ytt_checksum=c2781a30caf7f573dece6ec186ac0e97470d0de2eccf9fcf63f267c35495ac30
  else
    binary_type=linux-amd64
    
    ytt_checksum=d05f430ac18b3791d831f4cfd78371a7549f225dfaeb6fef2e5bfcd293d6c382
  fi

  echo "Installing ${binary_type} binaries..."

  
  echo "Installing ytt..."
  $dl_bin https://github.com/carvel-dev/ytt/releases/download/v0.45.0/ytt-${binary_type} > /tmp/ytt
  echo "${ytt_checksum}  /tmp/ytt" | shasum -c -
  mv /tmp/ytt ${dst_dir}/ytt
  chmod +x ${dst_dir}/ytt
  echo "Installed ${dst_dir}/ytt v0.45.0"
  
}

install'

    generateInstallSH "$testDir/ytt-release.yml" $outputFolder
    testAssertionOK "diff $testDir/expected-result.txt $outputFolder/install.sh.txt --ignore-blank-lines" "Expected results to have matched" 
}

TestInstallAddsHttpsProtocolWhenNotPresent() {
    createFileWithContent "ytt-release.yml" "
products:
- product: ytt
  version: v0.45.0
  github:
    url: github.com/carvel-dev/ytt
  assets:
  - os: linux
    arch: amd64
    shasum: d05f430ac18b3791d831f4cfd78371a7549f225dfaeb6fef2e5bfcd293d6c382
    filename: ytt-linux-amd64
  - os: linux
    arch: arm64
    shasum: 54e228823e851320b848d854218004299d2ff362e0fe9e287d5a52df502baaaf
    filename: ytt-linux-arm64
"

    generateInstallSH "$testDir/ytt-release.yml" $outputFolder
    testAssertionNotOK "grep -q "https://github.com/carvel-dev/ytt" $outputFolder/install.sh.txt" "Expected https to have been added to the file but it was not"
}

TestInstallReplacesHttpWithHttpsWhenHttpIsPresent() {
    createFileWithContent "ytt-release.yml" "
products:
- product: ytt
  version: v0.45.0
  github:
    url: http://github.com/carvel-dev/ytt
  assets:
  - os: linux
    arch: amd64
    shasum: d05f430ac18b3791d831f4cfd78371a7549f225dfaeb6fef2e5bfcd293d6c382
    filename: ytt-linux-amd64
  - os: linux
    arch: arm64
    shasum: 54e228823e851320b848d854218004299d2ff362e0fe9e287d5a52df502baaaf
    filename: ytt-linux-arm64
"

    generateInstallSH "$testDir/ytt-release.yml" $outputFolder
    testAssertionNotOK "grep -q "https://github.com/carvel-dev/ytt" $outputFolder/install.sh.txt" "Expected https to have been added to the file but it was not"
}

TestBasicInstallationScript
TestInstallAddsHttpsProtocolWhenNotPresent
TestInstallReplacesHttpWithHttpsWhenHttpIsPresent