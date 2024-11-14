#!/bin/bash

# Script to update package version in PKGBUILD
# Usage: ./update-pkgver.sh package-name new-version

if [ $# -ne 2 ]; then
    echo "Usage: $0 package-name new-version"
    exit 1
fi

PACKAGE=$1
VERSION=$2
PKGBUILD_PATH="packages/$PACKAGE/PKGBUILD"

if [ ! -f "$PKGBUILD_PATH" ]; then
    echo "Error: PKGBUILD not found for package $PACKAGE"
    exit 1
fi

# Update pkgver in PKGBUILD
sed -i "s/^pkgver=.*$/pkgver=$VERSION/" "$PKGBUILD_PATH"

# Reset pkgrel to 1
sed -i "s/^pkgrel=.*$/pkgrel=1/" "$PKGBUILD_PATH"

# Update checksums
cd "packages/$PACKAGE"
updpkgsums

echo "Updated $PACKAGE to version $VERSION"
