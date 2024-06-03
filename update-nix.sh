#!/usr/bin/env bash

set -xe

FILE="default.nix"

VERSION=$(git describe --tags --abbrev=0)

sed -e "s/version = \".*\";/version = \"${VERSION}\";/g" $FILE > $FILE.new && mv $FILE.new $FILE

nix-build -E "with import <nixpkgs> { }; callPackage ./$FILE { }"

SRC_SHA256=$(nix-build -E "with import <nixpkgs> { }; callPackage ./$FILE { }" 2>&1 | grep -oE 'got:\s+sha256-\S+' | cut -d "-" -f 2)
sed -e "s|sha256 = \"\";|sha256 = \"$SRC_SHA256\";|g" $FILE > $FILE.new && mv $FILE.new $FILE

VENDOR_SHA256=$(nix-build -E "with import <nixpkgs> { }; callPackage ./$FILE { }" 2>&1 | grep -oE 'got:\s+sha256-\S+' | cut -d "-" -f 2)
sed -e "s|vendorHash = \"\";|vendorHash = \"sha256-$VENDOR_SHA256\";|g" $FILE > $FILE.new && mv $FILE.new $FILE
