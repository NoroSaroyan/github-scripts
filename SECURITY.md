# Security Policy

## Supported Versions

We actively maintain and provide security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| Latest  | :white_check_mark: |
| < Latest| :x:                |

## Reporting a Vulnerability

We take the security of our scripts seriously. If you discover a security vulnerability, please follow these steps:

### 1. **Do Not** Create a Public Issue
Please do not report security vulnerabilities through public GitHub issues, discussions, or pull requests.

### 2. **Send a Private Report**
Create a private security advisory on GitHub.

Include the following information:
- Type of issue (e.g., code injection, privilege escalation, etc.)
- Full paths of source file(s) related to the manifestation of the issue
- The location of the affected source code (tag/branch/commit or direct URL)
- Any special configuration required to reproduce the issue
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the issue, including how an attacker might exploit it

### 3. **What to Expect**
- **Acknowledgment**: We will acknowledge receipt of your vulnerability report within 48 hours
- **Assessment**: We will assess the vulnerability and its impact within 5 business days
- **Updates**: We will provide regular updates on our progress
- **Resolution**: We aim to resolve critical vulnerabilities within 30 days

### 4. **Disclosure Timeline**
- We will work with you to coordinate disclosure
- We prefer responsible disclosure after a fix is available
- We will credit you in the security advisory (unless you prefer to remain anonymous)

## Security Best Practices for Users

### Script Execution
- **Review scripts** before running them on your system
- **Run with minimal privileges** - don't use sudo unless absolutely necessary
- **Test in non-production environments** first
- **Keep dependencies updated** (GitHub CLI, jq, etc.)

### GitHub Authentication
- **Use fine-grained personal access tokens** when possible
- **Regularly rotate** your GitHub credentials
- **Review token permissions** periodically
- **Don't share credentials** or commit them to repositories

### Repository Management
- **Backup important repositories** before running bulk operations
- **Test on a few repositories** before processing large batches
- **Review script outputs** for any unexpected behavior
- **Use dry-run modes** when available

## Common Security Considerations

### Input Validation
Our scripts include input validation, but always:
- **Verify repository names** before processing
- **Check selection ranges** to avoid unintended operations
- **Validate user permissions** for target repositories

### API Rate Limiting
- Scripts respect GitHub API rate limits
- **Monitor your API usage** in the GitHub settings
- **Use authenticated requests** for higher rate limits

### Error Handling
- Scripts include error handling for common scenarios
- **Check exit codes** and error messages
- **Report unexpected behaviors** through proper channels

## Security Updates

We will announce security updates through:
- **GitHub Security Advisories**
- **Release notes** with clear security indicators
- **README updates** for critical security information

## Contact

For any security-related questions or concerns:
- **Email**: noro.saroyan@gmail.com
- **GitHub Security Advisories**: Available in this repository
- **Encrypted communication**: Available upon request

---

Thank you for helping keep our project and community safe!
