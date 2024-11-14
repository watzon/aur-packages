# AUR Packages

This repository contains the PKGBUILDs and related files for AUR packages that I maintain. Each package is organized in its own directory and has automated workflows for version checking and AUR updates.

## Packages

- [postpilot-bin](./packages/postpilot-bin) - Binary package for PostPilot
- [windsurf](./packages/windsurf) - Package for Windsurf IDE
- [ztags-git](./packages/ztags-git) - Git package for ztags

## Repository Structure

```
.
├── README.md
├── packages/           # Directory containing individual package directories
│   ├── postpilot-bin/
│   ├── windsurf/
│   └── ztags-git/
└── scripts/           # Helper scripts for maintenance and automation
```

## Automated Package Management

Each package in this repository uses a two-pronged approach for automated updates:

1. **Version Checking** (`[package]_check.yml`)
   - Runs periodically to check for new upstream versions
   - Creates pull requests when updates are available
   - Builds and tests packages automatically
   - Runs package validation using `namcap`

2. **AUR Updates** (`[package]_update.yml`)
   - Triggers when a PKGBUILD is updated in the main branch
   - Automatically publishes updates to the AUR
   - Uses SSH key authentication for secure deployment
   - Updates package version and description

### Package Directory Contents

Each package directory contains:
- `PKGBUILD` - The build script for the package
- Additional files needed for the package (install scripts, patches, etc.)

### GitHub Workflows

Located in `.github/workflows/`:
- `[package]_check.yml` - Automated version checking and testing
- `[package]_update.yml` - AUR deployment workflow

### Helper Scripts

The `scripts/` directory contains various helper scripts:
- Version checking scripts for different package types
- Utility functions for package management
- Common operations shared between packages

## Contributing

If you find any issues with these packages:
1. Open an issue in this repository
2. Comment on the AUR package page
3. Submit a pull request with fixes

## License

This repository is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
