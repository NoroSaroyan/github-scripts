# Contributing to GitHub Scripts Collection

Thank you for your interest in contributing to this project! We welcome contributions from the community and appreciate your help in making this collection of GitHub automation tools better.

## 🚀 How to Contribute

### 1. Fork the Repository
- Click the "Fork" button at the top right of this repository
- Clone your fork to your local machine:
  ```bash
  git clone https://github.com/NoroSaroyan/github-scripts.git
  cd github-scripts
  ```

### 2. Create a Feature Branch
- Create a new branch for your feature or bug fix:
  ```bash
  git checkout -b feature/your-feature-name
  # or
  git checkout -b fix/issue-description
  ```

### 3. Make Your Changes
- Write your code following our coding standards (see below)
- Test your changes thoroughly
- Ensure your script works on different platforms if applicable

### 4. Commit Your Changes
- Write clear, descriptive commit messages:
  ```bash
  git add .
  git commit -m "Add feature: description of your changes"
  ```

### 5. Push and Create a Pull Request
- Push your branch to your fork:
  ```bash
  git push origin feature/your-feature-name
  ```
- Go to the original repository and click "New Pull Request"
- Fill out the pull request template with detailed information

## 📋 Coding Standards

### Script Requirements
All new scripts must:

1. **Start with a proper shebang**: `#!/bin/bash`
2. **Include error handling**: Check for required dependencies and validate inputs
3. **Use consistent formatting**: Follow the existing code style
4. **Include user-friendly prompts**: Clear instructions and interactive elements
5. **Handle edge cases**: Validate inputs and provide meaningful error messages

### Code Style Guidelines

```bash
# Good: Clear variable names and proper error checking
if ! command -v gh &>/dev/null; then
    echo "Error: GitHub CLI (gh) is required but not installed."
    exit 1
fi

# Good: User-friendly prompts with defaults
read -rp "Enter GitHub username: " USERNAME
read -rp "Enter permission level (pull/push/admin), default 'push': " PERM
PERM=${PERM:-push}

# Good: Input validation
if [[ -z "$USERNAME" ]]; then
    echo "Error: Username cannot be empty."
    exit 1
fi
```

### Documentation Requirements

Each new script must include:

1. **Header comment** explaining what the script does
2. **Usage examples** in comments
3. **Dependencies** clearly listed
4. **Error handling** for common failure scenarios

## 🧪 Testing

Before submitting a pull request:

1. **Test your script** with various inputs and edge cases
2. **Verify compatibility** with both macOS and Linux (if applicable)
3. **Check error handling** by providing invalid inputs
4. **Ensure dependencies** are properly checked

### Test Checklist
- [ ] Script runs without syntax errors
- [ ] All user inputs are validated
- [ ] Error messages are clear and helpful
- [ ] Script handles missing dependencies gracefully
- [ ] Interactive prompts work as expected
- [ ] Selection logic (ranges, individual items, "all") works correctly

## 📝 Pull Request Guidelines

### Before Submitting
- [ ] Your code follows the project's coding standards
- [ ] You have tested your changes thoroughly
- [ ] You have updated documentation if necessary
- [ ] Your commit messages are clear and descriptive

### Pull Request Template
When creating a pull request, please include:

1. **Description**: What does this PR do?
2. **Type of Change**: Bug fix, new feature, documentation update, etc.
3. **Testing**: How did you test your changes?
4. **Screenshots**: If applicable, add screenshots showing the script in action
5. **Related Issues**: Link any related issues

### Example PR Description
```markdown
## Description
Adds a new script for bulk repository tagging with interactive selection.

## Type of Change
- [x] New feature
- [ ] Bug fix
- [ ] Documentation update

## Testing
- Tested with 50+ repositories
- Verified input validation with invalid selections
- Tested on macOS and Ubuntu

## Screenshots
[Include screenshots of the script running]
```

## 🐛 Reporting Issues

### Bug Reports
When reporting bugs, please include:
- Script name and version
- Operating system and shell version
- Steps to reproduce the issue
- Expected vs actual behavior
- Error messages (if any)

### Feature Requests
For new features:
- Describe the use case
- Explain why this would be valuable
- Provide examples of how it would work

## 🔍 Code Review Process

1. **Automated Checks**: PRs will be automatically checked for basic requirements
2. **Maintainer Review**: A project maintainer will review your code
3. **Testing**: Changes will be tested in different environments
4. **Feedback**: You may receive feedback and requests for changes
5. **Merge**: Once approved, your PR will be merged

## 📞 Getting Help

- **Questions**: Open an issue with the "question" label
- **Discussions**: Use GitHub Discussions for general conversations
- **Direct Contact**: For sensitive issues, contact the maintainer directly

## 📜 Code of Conduct

This project follows a simple code of conduct:
- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and improve
- Maintain a professional environment

## 🏆 Recognition

Contributors will be recognized in:
- The project's README file
- Release notes for significant contributions
- GitHub's contributor graph

Thank you for contributing to the GitHub Scripts Collection! 🎉
