#!/usr/bin/env bash

set -e

echo "Downloading recommended terraform-docs versions"
echo "================================================"

ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    ARCH="amd64"
elif [[ "$ARCH" == arm* ]]; then
    ARCH="arm64"
fi

echo "Detected architecture: $ARCH"
echo ""

VERSIONS=("0.6.0" "0.8.2" "0.10.1" "0.15.0" "0.19.0")

for VERSION in "${VERSIONS[@]}"; do
    echo "Downloading terraform-docs v$VERSION..."
    
    TEMP_DIR="/tmp/terraform-docs-$VERSION"
    mkdir -p "$TEMP_DIR"
    
    DOWNLOAD_ARCH="$ARCH"
    if [[ "$ARCH" == "arm64" ]]; then
        case "$VERSION" in
            0.6.0|0.8.2|0.10.1)
                DOWNLOAD_ARCH="amd64"
                echo "  Using Intel binary (Rosetta 2)"
                ;;
        esac
    fi
    
    case "$VERSION" in
        0.6.0|0.8.2|0.10.1)
            URL="https://github.com/terraform-docs/terraform-docs/releases/download/v$VERSION/terraform-docs-v$VERSION-darwin-$DOWNLOAD_ARCH"
            
            if curl -L -f -o "$TEMP_DIR/terraform-docs" "$URL" 2>&1; then
                sudo cp "$TEMP_DIR/terraform-docs" "/usr/local/bin/terraform-docs-$VERSION"
                sudo chmod +x "/usr/local/bin/terraform-docs-$VERSION"
                echo "  terraform-docs v$VERSION installed"
            else
                echo "  Failed to download terraform-docs v$VERSION"
                echo "  URL: $URL"
            fi
            ;;
        *)
            URL="https://github.com/terraform-docs/terraform-docs/releases/download/v$VERSION/terraform-docs-v$VERSION-darwin-$DOWNLOAD_ARCH.tar.gz"
            
            if curl -L -f -o "$TEMP_DIR/terraform-docs.tar.gz" "$URL" 2>&1; then
                if tar -xzf "$TEMP_DIR/terraform-docs.tar.gz" -C "$TEMP_DIR" 2>/dev/null; then
                    sudo cp "$TEMP_DIR/terraform-docs" "/usr/local/bin/terraform-docs-$VERSION"
                    sudo chmod +x "/usr/local/bin/terraform-docs-$VERSION"
                    echo "  terraform-docs v$VERSION installed"
                else
                    echo "  Failed to extract terraform-docs v$VERSION"
                fi
            else
                echo "  Failed to download terraform-docs v$VERSION"
                echo "  URL: $URL"
            fi
            ;;
    esac
    
    rm -rf "$TEMP_DIR"
done

echo ""
echo "Setting up default version..."

if command -v terraform-docs &> /dev/null; then
    CURRENT_VERSION=$(terraform-docs --version 2>/dev/null | grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' | sed 's/v//')
    echo "Current terraform-docs version: v$CURRENT_VERSION"
else
    echo "No terraform-docs currently active, setting default to v0.15.0..."
    sudo ln -sf "/usr/local/bin/terraform-docs-0.15.0" "/usr/local/bin/terraform-docs"
fi

echo ""
echo "Setup complete!"
echo ""
echo "Installed versions:"
ls -la /usr/local/bin/terraform-docs-* 2>/dev/null | grep -v "terraform-docs$" || echo "  No versioned binaries found"

echo ""
echo "Current active version:"
if command -v terraform-docs &> /dev/null; then
    terraform-docs --version
else
    echo "  terraform-docs not found in PATH"
fi

echo ""
echo "Use ./tfversions to switch between versions"
echo ""
echo "Version compatibility:"
echo "  Terraform 0.11 -> terraform-docs v0.6.0"
echo "  Terraform 0.12 -> terraform-docs v0.8.2"
echo "  Terraform 0.13 -> terraform-docs v0.10.1"
echo "  Terraform 1.x  -> terraform-docs v0.15.0"
echo "  Terraform 1.9+ -> terraform-docs v0.19.0"