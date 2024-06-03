#!/usr/bin/env bash

FILE="default.nix"

sed -i '' -e "s/__VERSION__/$(git describe --tags --abbrev=0)/g" "$FILE"

nix-build -E "with import <nixpkgs> { }; callPackage ./$FILE { }"
SRC_SHA256=$(nix-build -E "with import <nixpkgs> { }; callPackage ./$FILE { }" 2>&1 | grep -oE 'got:\s+sha256-\S+' | cut -d "-" -f 2)
sed -i '' -e "s|sha256 = \"\";|sha256 = \"$SRC_SHA256\";|g" "$FILE"

VENDOR_SHA256=$(nix-build -E "with import <nixpkgs> { }; callPackage ./$FILE { }" 2>&1 | grep -oE 'got:\s+sha256-\S+' | cut -d "-" -f 2)
sed -i '' -e "s|vendorHash = \"\";|vendorHash = \"sha256-$VENDOR_SHA256\";|g" "$FILE"
