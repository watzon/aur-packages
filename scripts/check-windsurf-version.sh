#!/bin/bash

# Set up temporary directory
TEMP_DIR=$(mktemp -d)
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Download and set up the repository key
curl -fsSL "https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/windsurf.gpg" -o "$TEMP_DIR/windsurf.gpg"
gpg --dearmor < "$TEMP_DIR/windsurf.gpg" > "$TEMP_DIR/windsurf-stable-archive-keyring.gpg"

# Create sources list
echo "deb [signed-by=$TEMP_DIR/windsurf-stable-archive-keyring.gpg arch=amd64] https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/apt stable main" > "$TEMP_DIR/windsurf.list"

# Update package lists for the repository
apt-get -o Dir::Etc::sourcelist="$TEMP_DIR/windsurf.list" \
        -o Dir::Etc::sourceparts="-" \
        -o APT::Get::List-Cleanup="0" \
        -o Dir::Etc::trusted="$TEMP_DIR/trusted.gpg" \
        -o Dir::Etc::trustedparts="-" \
        -o Debug::NoLocking="1" \
        update 2>/dev/null

# Get package version
VERSION=$(apt-cache madison windsurf | head -n1 | awk '{ print $3 }' | cut -d'-' -f1)

if [ -n "$VERSION" ]; then
    # Verify that the deb file exists
    DEB_URL="https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/apt/pool/main/w/windsurf/Windsurf-linux-x64-${VERSION}.deb"
    if curl --output /dev/null --silent --head --fail "$DEB_URL"; then
        echo "$VERSION"
        exit 0
    else
        echo "Deb package not found at $DEB_URL" >&2
        exit 1
    fi
else
    echo "Failed to get version" >&2
    exit 1
fi
