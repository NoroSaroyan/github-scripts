# GitHub Scripts Collection

A comprehensive collection of shell scripts designed to streamline GitHub repository management tasks. These tools leverage the GitHub CLI to automate common operations across multiple repositories.

## 🚀 Prerequisites

Before using any script in this collection, ensure you have the following installed:

- **GitHub CLI (`gh`)**: [Installation Guide](https://cli.github.com/)
- **jq**: JSON processor for parsing API responses
  ```bash
  # macOS
  brew install jq
  
  # Ubuntu/Debian
  sudo apt-get install jq
  
  # Windows (using Chocolatey)
  choco install jq
  ```

## 📋 Available Scripts

### 🔒 Mass Privatize Repositories (`mass-privatize-repos.sh`)

Efficiently convert multiple public repositories to private with an interactive selection interface.

#### Features
- Interactive repository selection with support for individual repos, ranges, or all repos
- Dry-run mode for testing (modify `DRY_RUN=true` in the script)
- Robust error handling and validation
- Real-time progress feedback

#### Usage

1. **Download the script:**
   ```bash
   curl -O https://raw.githubusercontent.com/NoroSaroyan/github-scripts/main/mass-privatize-repos.sh
   chmod +x mass-privatize-repos.sh
   ```

2. **Run the script:**
   ```bash
   ./mass-privatize-repos.sh
   ```

3. **Follow the interactive prompts:**
   - Enter your GitHub username
   - Authenticate with GitHub CLI (if not already logged in)
   - Select repositories using various formats:
     - Single repos: `1,3,5`
     - Ranges: `1-5,8,10-12`
     - All repos: `all`

#### Selection Examples
```
# Make repositories 1, 3, and 5 private
1,3,5

# Make repositories 1 through 5 and repository 8 private
1-5,8

# Make all public repositories private
all
```

#### Safety Features
- Validates repository indices to prevent errors
- Shows repository list before selection
- Confirms each operation with detailed output
- Graceful error handling for failed operations

### 🌐 Mass Publicize Repositories (`mass-publicize-repos.sh`)

Convert multiple private repositories to public with an intuitive selection interface. Perfect for open-sourcing projects or making repositories publicly accessible.

#### Features
- Interactive repository selection with support for individual repos, ranges, or all repos
- Automatic fetching of all private repositories
- Input validation and error handling
- Real-time progress feedback with detailed status messages

#### Usage

1. **Download the script:**
   ```bash
   curl -O https://raw.githubusercontent.com/NoroSaroyan/github-scripts/main/mass-publicize-repos.sh
   chmod +x mass-publicize-repos.sh
   ```

2. **Run the script:**
   ```bash
   ./mass-publicize-repos.sh
   ```

3. **Follow the interactive prompts:**
   - Enter your GitHub username
   - Authenticate with GitHub CLI (if not already logged in)
   - Select repositories using various formats:
     - Single repos: `1,3,5`
     - Ranges: `1-5,8,10-12`
     - All repos: `all`

#### Selection Examples
```
# Make repositories 1, 3, and 5 public
1,3,5

# Make repositories 1 through 5 and repository 8 public
1-5,8

# Make all private repositories public
all
```

#### Important Notes
- **⚠️ Caution**: Making repositories public exposes all code, commits, and history
- The script automatically accepts visibility change consequences
- Failed operations are clearly reported with error messages
- Only processes private repositories (public repos are filtered out)

### 🔧 Other Scripts

This repository contains additional scripts for various GitHub management tasks:

- **`add-multiple-collaborators.sh`** - Add multiple collaborators to a repository
- **`bulk-clone.sh`** - Clone multiple repositories at once
- **`github-stats-report.sh`** - Generate detailed activity reports
- **`mass-archive-inactive-repos.sh`** - Archive repositories based on inactivity
- **`mass-publicize-repos.sh`** - Convert private repositories to public
- **`repo-detailed-report.sh`** - Generate comprehensive repository reports
- **`repos-bulk-report.sh`** - Create bulk repository analysis reports

*Detailed documentation for these scripts will be added as the collection grows.*

## 🛡️ Security & Best Practices

- **Authentication**: All scripts use GitHub CLI's secure authentication
- **Rate Limiting**: Scripts respect GitHub API rate limits
- **Error Handling**: Comprehensive error checking and user feedback
- **Dry Run**: Many scripts support dry-run mode for safe testing

## 🤝 Contributing

This is an evolving collection of GitHub automation tools. Contributions, suggestions, and improvements are welcome!

### Adding New Scripts
When contributing new scripts, please ensure they:
- Follow the existing code style and structure
- Include proper error handling
- Provide user-friendly interactive prompts
- Include comprehensive comments
- Are tested with various scenarios

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🆘 Support

If you encounter issues:
1. Ensure all prerequisites are installed and up to date
2. Verify GitHub CLI authentication: `gh auth status`
3. Check that you have the necessary permissions for the repositories
4. Review the script output for specific error messages

For bugs or feature requests, please open an issue in this repository.

---

**Made with ❤️ for the GitHub community**
