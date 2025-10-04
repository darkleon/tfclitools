# Terraform Tools CLI Manager

Production-ready scripts for installing and managing Terraform, Terragrunt, and terraform-docs versions on Apple Silicon Macs (M1/M2/M3/M4).

## Goal

Simplify version management of Terraform toolchain on Apple Silicon Macs by:
- Installing multiple versions side-by-side
- Seamless switching between versions
- Automatic Rosetta 2 compatibility for legacy versions
- Interactive CLI interface similar to kubectx/kubens

## Features

- **Apple Silicon Native**: Optimized for M-series chips with Rosetta 2 fallback for older versions
- **Multi-Version Support**: Install and manage multiple versions of each tool
- **Interactive Interface**: Easy navigation with arrow keys
- **Version File Detection**: Automatically detects `.terraform-version` and `.terragrunt-version` files
- **One-Click Version Sync**: Apply all project versions with a single keypress
- **Smart Recommendations**: Suggests compatible terraform-docs versions based on Terraform version
- **Production Ready**: Clean, minimal output with proper error handling

## Version Compatibility Matrix

### Recommended Version Combinations

| Terraform Version | Terragrunt Version | terraform-docs Version | Notes |
|-------------------|-------------------|------------------------|-------|
| 1.9.x - 1.10.x | 0.66.x - 0.67.x | 0.19.0 | Latest stable, M-series native |
| 1.5.x - 1.8.x | 0.50.x - 0.65.x | 0.15.0 - 0.18.0 | Recommended for production |
| 1.0.x - 1.4.x | 0.38.x - 0.48.x | 0.15.0 | Long-term support |
| 0.15.x | 0.31.x - 0.35.x | 0.14.1 | Legacy support |
| 0.13.x - 0.14.x | 0.28.x - 0.30.x | 0.10.1 | Legacy (Rosetta 2) |
| 0.12.x | 0.23.x - 0.27.x | 0.8.2 | Legacy (Rosetta 2) |
| 0.11.x | 0.18.x - 0.22.x | 0.6.0 | Legacy (Rosetta 2) |

### Tool-Specific Version Support

#### Terraform
- **Native ARM64**: v1.0.2+ (recommended for M-series)
- **Intel (Rosetta 2)**: v0.11.0 - v1.0.1

#### Terragrunt
- **Native ARM64**: v0.38.0+ (recommended for M-series)
- **Intel (Rosetta 2)**: All versions < v0.38.0

#### terraform-docs
- **Native ARM64**: v0.15.0+ (recommended for M-series)
- **Intel (Rosetta 2)**: v0.6.0 - v0.14.x

## Prerequisites

### Required
- macOS with Apple Silicon (M1/M2/M3/M4)
- Homebrew package manager
- Rosetta 2 (for legacy versions)

### Install Rosetta 2 (if needed)
```bash
softwareupdate --install-rosetta
```

### Install Homebrew (if needed)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Installation

### 1. Quick Setup (Recommended)
```bash
# Clone or download the repository
cd tfclitools

# Make scripts executable
chmod +x setup_tfversions.sh
chmod +x install_terraform_docs_versions.sh
chmod +x tfversions

# Run setup script
./setup_tfversions.sh
```

This installs:
- tfenv (Terraform version manager)
- tgenv (Terragrunt version manager)
- terraform-docs
- Common versions of each tool

### 2. Install terraform-docs Multiple Versions
```bash
./install_terraform_docs_versions.sh
```

This installs terraform-docs versions: 0.6.0, 0.8.2, 0.10.1, 0.15.0, 0.19.0

### 3. Add to PATH (Optional)
```bash
# Add to ~/.zshrc
export PATH="$PATH:/Users/yourusername/tfclitools"

# Reload shell
source ~/.zshrc
```

## Usage

### Interactive Version Manager
```bash
./tfversions
```

**Version File Detection:**
When you run `tfversions` in a directory containing `.terraform-version` and/or `.terragrunt-version` files, it will:
- Automatically detect the required versions
- Show a comparison table with current vs. required versions
- Recommend a compatible terraform-docs version
- Offer to apply all versions automatically with one keypress

**Navigation:**
- `↑/↓` - Navigate between tools and versions
- `Enter` - Select tool or switch version
- `a` - Apply all detected versions (when version files are present)
- `ESC` - Go back or exit
- `Ctrl+C` - Exit application

### Example with Version Files

Create version files in your project:
```bash
echo "1.5.7" > .terraform-version
echo "0.50.17" > .terragrunt-version
```

Run `tfversions` and you'll see:
```
Detected Version Configuration:
--------------------------------------------------------------------------------
Tool                 File Version         Current Version      Action              
--------------------------------------------------------------------------------
Terraform            v1.5.7               v1.4.6               Switch needed
Terragrunt           v0.50.17             v0.48.7              Switch needed
terraform-docs       v0.15.0              v0.19.0              Switch needed
--------------------------------------------------------------------------------
Press 'a' to apply all detected versions automatically
```

Press `a` to automatically install and switch all tools to the detected versions.

### Manual Version Management

#### Terraform
```bash
# List installed versions
tfenv list

# Install specific version
tfenv install 1.5.7

# Switch version
tfenv use 1.5.7

# Install and use latest
tfenv install latest
tfenv use latest
```

#### Terragrunt
```bash
# List installed versions
tgenv list

# Install specific version
tgenv install 0.50.17

# Switch version
tgenv use 0.50.17

# Install and use latest
tgenv install latest
tgenv use latest
```

#### terraform-docs
```bash
# List installed versions
ls -l /usr/local/bin/terraform-docs-*

# Switch version manually
sudo ln -sf /usr/local/bin/terraform-docs-0.19.0 /usr/local/bin/terraform-docs

# Check current version
terraform-docs --version
```

## Architecture Support

### Apple Silicon (M-series)
- Automatically detects ARM64 architecture
- Uses native binaries when available
- Falls back to Intel binaries with Rosetta 2 for older versions

### Intel Macs
- Uses AMD64 binaries natively
- No Rosetta 2 required

## File Structure

```
tfclitools/
├── setup_tfversions.sh              # Initial setup script
├── install_terraform_docs_versions.sh # terraform-docs multi-version installer
├── tfversions                        # Interactive version switcher
└── README.md                         # This file
```

## Installed Binaries

### Version Managers (via Homebrew)
```
/opt/homebrew/bin/tfenv
/opt/homebrew/bin/tgenv
```

### Versioned Binaries
```
/usr/local/bin/terraform-docs-0.6.0
/usr/local/bin/terraform-docs-0.8.2
/usr/local/bin/terraform-docs-0.10.1
/usr/local/bin/terraform-docs-0.15.0
/usr/local/bin/terraform-docs-0.19.0
/usr/local/bin/terraform-docs -> terraform-docs-0.15.0 (symlink)
```

## Troubleshooting

### No tools found
Ensure version managers are installed:
```bash
brew install tfenv tgenv terraform-docs
```

### No versions available
Install some versions first:
```bash
tfenv install 1.5.7
tgenv install 0.50.17
```

### Rosetta 2 errors
Install Rosetta 2:
```bash
softwareupdate --install-rosetta --agree-to-license
```

### Permission denied errors
Ensure scripts are executable:
```bash
chmod +x setup_tfversions.sh install_terraform_docs_versions.sh tfversions
```

### Binary not found after switching
Refresh shell or check PATH:
```bash
source ~/.zshrc
which terraform
which terragrunt
which terraform-docs
```

## Common Workflows

### Project with Version Files (Recommended)
```bash
# Create version files in your project
echo "1.5.7" > .terraform-version
echo "0.50.17" > .terragrunt-version

# Run tfversions
./tfversions

# Press 'a' to apply all versions automatically
# All tools will be installed and switched to the correct versions
```

### New Project Setup
```bash
# Set versions for Terraform 1.5.x project
tfenv use 1.5.7
tgenv use 0.50.17
sudo ln -sf /usr/local/bin/terraform-docs-0.15.0 /usr/local/bin/terraform-docs

# Verify versions
terraform --version
terragrunt --version
terraform-docs --version
```

### Legacy Project (Terraform 0.12)
```bash
# Switch to legacy versions
tfenv install 0.12.31
tfenv use 0.12.31
tgenv install 0.25.5
tgenv use 0.25.5
sudo ln -sf /usr/local/bin/terraform-docs-0.8.2 /usr/local/bin/terraform-docs
```

### Upgrade Workflow
```bash
# Install new versions
tfenv install 1.9.0
tgenv install 0.66.0
./install_terraform_docs_versions.sh  # If new version added

# Test with new versions
tfenv use 1.9.0
tgenv use 0.66.0

# Rollback if needed
tfenv use 1.5.7
tgenv use 0.50.17
```

## Version Update Guide

### Updating This Tool

1. Check for new versions:
   - Terraform: https://github.com/hashicorp/terraform/releases
   - Terragrunt: https://github.com/gruntwork-io/terragrunt/releases
   - terraform-docs: https://github.com/terraform-docs/terraform-docs/releases

2. Update version arrays in scripts:
   ```bash
   # In setup_tfversions.sh
   TERRAFORM_VERSIONS=("1.9.0" "1.5.7" "1.4.6" "1.3.9")
   TERRAGRUNT_VERSIONS=("0.66.0" "0.50.17" "0.48.7" "0.45.16")
   
   # In install_terraform_docs_versions.sh
   VERSIONS=("0.6.0" "0.8.2" "0.10.1" "0.15.0" "0.19.0")
   ```

3. Test installation on clean system

## Best Practices

1. **Version Pinning**: Always use `.terraform-version` and `.terragrunt-version` files in your projects
   ```bash
   # In your project root
   echo "1.5.7" > .terraform-version
   echo "0.50.17" > .terragrunt-version
   git add .terraform-version .terragrunt-version
   ```

2. **Use tfversions for Switching**: Use `./tfversions` and press 'a' to sync to project versions
3. **Testing**: Test version upgrades in non-production environments first
4. **Documentation**: Commit version files to ensure team consistency
5. **Compatibility**: Check compatibility matrix before upgrading
6. **Native Versions**: Prefer native ARM64 versions on M-series Macs for better performance

## Performance Notes

- **Native ARM64**: ~30-40% faster than Intel binaries on M-series
- **Rosetta 2 Overhead**: ~5-10% performance penalty, negligible for most workflows
- **Recommendation**: Use native versions (Terraform 1.0.2+, Terragrunt 0.38.0+, terraform-docs 0.15.0+) when possible

## License

MIT License - Free for personal and commercial use

## Contributing

Contributions welcome! Please test thoroughly on Apple Silicon before submitting PRs.

## Support

For issues specific to:
- **tfenv**: https://github.com/tfutils/tfenv
- **tgenv**: https://github.com/cunymatthieu/tgenv  
- **terraform-docs**: https://github.com/terraform-docs/terraform-docs

For issues with these scripts, please open an issue in this repository.