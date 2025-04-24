#!/bin/bash

set -x  # Enable debug output

# Set up temporary directory
TEMP_DIR=$(mktemp -d)

cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Download and set up the repository key
curl -fsSL "https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/windsurf.gpg" -o "$TEMP_DIR/windsurf.gpg"

# Add the key to apt's trusted keys
cat "$TEMP_DIR/windsurf.gpg" | sudo gpg --batch --yes --dearmor -o "/usr/share/keyrings/windsurf-archive-keyring.gpg"

# Create sources list
echo "deb [signed-by=/usr/share/keyrings/windsurf-archive-keyring.gpg arch=amd64] https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/apt stable main" | sudo tee /etc/apt/sources.list.d/windsurf.list > /dev/null

# Update package lists for the repository
sudo apt-get update > /dev/null 2>&1

# Get package version
VERSION=$(sudo apt-cache madison windsurf | head -n1 | awk '{ print $3 }' | cut -d'-' -f1)

if [ -n "$VERSION" ]; then
    # Verify that the deb file exists
    DEB_URL="https://windsurf-stable.codeiumdata.com/wVxQEIWkwPUEAGf3/apt/pool/main/w/windsurf/Windsurf-linux-x64-${VERSION}.deb"
    if curl --output /dev/null --silent --head --fail "$DEB_URL"; then
        # Download the DEB file to calculate SHA256 sum
        DEB_FILE="$TEMP_DIR/Windsurf-linux-x64-${VERSION}.deb"
        if curl --silent --output "$DEB_FILE" "$DEB_URL"; then
            # Calculate SHA256 sum
            SHA256SUM=$(sha256sum "$DEB_FILE" | awk '{print $1}')
            # Output version and SHA256 sum
            printf "%s %s" "$VERSION" "$SHA256SUM"
            exit 0
        else
            echo "Failed to download DEB package from $DEB_URL" >&2
            exit 1
        fi
    else
        echo "Deb package not found at $DEB_URL" >&2
        exit 1
    fi
else
    echo "Failed to get version" >&2
    exit 1
fi
