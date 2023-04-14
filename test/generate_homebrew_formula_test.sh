#!/bin/bash

set -eu

source "$(dirname "$0")/assertions.sh"

generateHomeBrewFormula() {
    ./scripts/generate_homebrew_formula.sh $1 > ./tmp/result.rb
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
    mkdir -p ./tmp
    cat <<EOF >./tmp/$1
$2
EOF
}

removeTestDirectory() {
    rm -r tmp
}

TestKappHomebrewFormula() {
    createFileWithContent "kapp-release.yml" "
#@data/values
---
product: kapp
version: v0.38.0
github:
  url: 'github.com/carvel-dev/kapp'
assets:
  - os: 'darwin'
    arch: 'amd64'
    shasum: 'kapp-darwin-amd64-shasum'
    filename: 'kapp-darwin-amd64'
  - os: 'darwin'
    arch: 'arm64'
    shasum: 'kapp-darwin-arm64-shasum'
    filename: 'kapp-darwin-arm64'
  - os: 'linux'
    arch: 'amd64'
    shasum: 'kapp-linux-amd64-shasum'
    filename: 'kapp-linux-amd64'
  - os: 'linux'
    arch: 'arm64'
    shasum: 'kapp-linux-arm64-shasum'
    filename: 'kapp-linux-arm64' "

    createFileWithContent "expected-result.rb" '
class Kapp < Formula
  desc "Kapp"
  homepage "https://carvel.dev/kapp/"
  version "v0.38.0"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/carvel-dev/kapp/releases/download/v0.38.0/kapp-darwin-arm64"
      sha256 "kapp-darwin-arm64-shasum"
    else
      url "https://github.com/carvel-dev/kapp/releases/download/v0.38.0/kapp-darwin-amd64"
      sha256 "kapp-darwin-amd64-shasum"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/carvel-dev/kapp/releases/download/v0.38.0/kapp-linux-arm64"
      sha256 "kapp-linux-arm64-shasum"
    else
      url "https://github.com/carvel-dev/kapp/releases/download/v0.38.0/kapp-linux-amd64"
      sha256 "kapp-linux-amd64-shasum"
    end
  end

  def install
    bin.install stable.url.split("/")[-1] => "kapp"
    
  end

  test do
    system "#{bin}/kapp", "version"
  end
end'

    generateHomeBrewFormula "./tmp/kapp-release.yml"
    testAssertionOK "diff ./tmp/expected-result.rb ./tmp/result.rb --ignore-blank-lines" "Expected results to have matched" 
}

TestImgpkgHomebrewFormula() {
    createFileWithContent "imgpkg-release.yml" "
#@data/values
---
product: imgpkg
version: v0.38.0
github:
  url: 'github.com/carvel-dev/imgpkg'
assets:
  - os: 'darwin'
    arch: 'amd64'
    shasum: 'imgpkg-darwin-amd64-shasum'
    filename: 'imgpkg-darwin-amd64'
  - os: 'darwin'
    arch: 'arm64'
    shasum: 'imgpkg-darwin-arm64-shasum'
    filename: 'imgpkg-darwin-arm64'
  - os: 'linux'
    arch: 'amd64'
    shasum: 'imgpkg-linux-amd64-shasum'
    filename: 'imgpkg-linux-amd64'
  - os: 'linux'
    arch: 'arm64'
    shasum: 'imgpkg-linux-arm64-shasum'
    filename: 'imgpkg-linux-arm64' "

    createFileWithContent "expected-result.rb" '
class Imgpkg < Formula
  desc "Imgpkg"
  homepage "https://carvel.dev/imgpkg/"
  version "v0.38.0"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/carvel-dev/imgpkg/releases/download/v0.38.0/imgpkg-darwin-arm64"
      sha256 "imgpkg-darwin-arm64-shasum"
    else
      url "https://github.com/carvel-dev/imgpkg/releases/download/v0.38.0/imgpkg-darwin-amd64"
      sha256 "imgpkg-darwin-amd64-shasum"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/carvel-dev/imgpkg/releases/download/v0.38.0/imgpkg-linux-arm64"
      sha256 "imgpkg-linux-arm64-shasum"
    else
      url "https://github.com/carvel-dev/imgpkg/releases/download/v0.38.0/imgpkg-linux-amd64"
      sha256 "imgpkg-linux-amd64-shasum"
    end
  end

  def install
    bin.install stable.url.split("/")[-1] => "imgpkg"
    
  end

  test do
    system "#{bin}/imgpkg", "version"
  end
end'

    generateHomeBrewFormula "./tmp/imgpkg-release.yml"   
    testAssertionOK "diff ./tmp/expected-result.rb ./tmp/result.rb --ignore-blank-lines" "Expected results to have matched"
}

TestKctrlHomebrewFormula() {
    createFileWithContent "kctrl-release.yml" "
#@data/values
---
product: kctrl
version: v0.38.0
github:
  url: 'github.com/carvel-dev/kapp-controller'
assets:
  - os: 'darwin'
    arch: 'amd64'
    shasum: 'kctrl-darwin-amd64-shasum'
    filename: 'kctrl-darwin-amd64'
  - os: 'darwin'
    arch: 'arm64'
    shasum: 'kctrl-darwin-arm64-shasum'
    filename: 'kctrl-darwin-arm64'
  - os: 'linux'
    arch: 'amd64'
    shasum: 'kctrl-linux-amd64-shasum'
    filename: 'kctrl-linux-amd64'
  - os: 'linux'
    arch: 'arm64'
    shasum: 'kctrl-linux-arm64-shasum'
    filename: 'kctrl-linux-arm64' "

    createFileWithContent "expected-result.rb" '
class Kctrl < Formula
  desc "Kctrl"
  homepage "https://carvel.dev/kapp-controller/"
  version "v0.38.0"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/carvel-dev/kapp-controller/releases/download/v0.38.0/kctrl-darwin-arm64"
      sha256 "kctrl-darwin-arm64-shasum"
    else
      url "https://github.com/carvel-dev/kapp-controller/releases/download/v0.38.0/kctrl-darwin-amd64"
      sha256 "kctrl-darwin-amd64-shasum"
    end
  elsif OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/carvel-dev/kapp-controller/releases/download/v0.38.0/kctrl-linux-arm64"
      sha256 "kctrl-linux-arm64-shasum"
    else
      url "https://github.com/carvel-dev/kapp-controller/releases/download/v0.38.0/kctrl-linux-amd64"
      sha256 "kctrl-linux-amd64-shasum"
    end
  end

  def install
    bin.install stable.url.split("/")[-1] => "kctrl"
    
  end

  test do
    system "#{bin}/kctrl", "version"
  end
end'

    generateHomeBrewFormula "./tmp/kctrl-release.yml"
    testAssertionOK "diff ./tmp/expected-result.rb ./tmp/result.rb --ignore-blank-lines" "Expected results to have matched"
}

TestKappHomebrewFormula
TestImgpkgHomebrewFormula
TestKctrlHomebrewFormula

removeTestDirectory
