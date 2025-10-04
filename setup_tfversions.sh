#!/usr/bin/env bash

set -e

echo "Setting up Terraform Tools Version Manager"
echo "==========================================="

if ! command -v brew &> /dev/null; then
    echo "ERROR: Homebrew not found. Please install Homebrew first:"
    echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

echo "Installing version managers..."

if ! command -v tfenv &> /dev/null; then
    echo "Installing tfenv..."
    brew install tfenv
else
    echo "tfenv already installed"
fi

if ! command -v tgenv &> /dev/null; then
    echo "Installing tgenv..."
    brew install tgenv
else
    echo "tgenv already installed"
fi

if ! command -v terraform-docs &> /dev/null; then
    echo "Installing terraform-docs..."
    brew install terraform-docs
else
    echo "terraform-docs already installed"
fi

echo ""
echo "Installing common Terraform versions..."

TERRAFORM_VERSIONS=("1.5.7" "1.4.6" "1.3.9" "1.2.9")
for version in "${TERRAFORM_VERSIONS[@]}"; do
    echo "Installing Terraform v$version..."
    if tfenv list | grep -q "$version"; then
        echo "  v$version already installed"
    else
        tfenv install "$version" || echo "  WARNING: Failed to install v$version"
    fi
done

echo ""
echo "Installing common Terragrunt versions..."

TERRAGRUNT_VERSIONS=("0.50.17" "0.48.7" "0.45.16" "0.42.7")
for version in "${TERRAGRUNT_VERSIONS[@]}"; do
    echo "Installing Terragrunt v$version..."
    if tgenv list | grep -q "$version"; then
        echo "  v$version already installed"
    else
        tgenv install "$version" || echo "  WARNING: Failed to install v$version"
    fi
done

echo ""
echo "Setting default versions..."

echo "Setting Terraform to latest installed version..."
tfenv use $(tfenv list | head -n1 | sed 's/\*//' | xargs) || true

echo "Setting Terragrunt to latest installed version..."
tgenv use $(tgenv list | head -n1 | sed 's/\*//' | xargs) || true

echo ""
echo "Setup complete!"
echo ""
echo "Installed tools:"
echo "  tfenv: $(tfenv --version 2>/dev/null || echo 'unknown')"
echo "  tgenv: $(tgenv --version 2>/dev/null || echo 'unknown')"
echo "  terraform-docs: $(terraform-docs --version 2>/dev/null || echo 'unknown')"
echo ""
echo "Current versions:"
echo "  Terraform: $(terraform --version 2>/dev/null | head -n1 || echo 'not found')"
echo "  Terragrunt: $(terragrunt --version 2>/dev/null || echo 'not found')"
echo "  terraform-docs: $(terraform-docs --version 2>/dev/null || echo 'not found')"
echo ""
echo "Run ./tfversions to manage versions"