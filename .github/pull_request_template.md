name: Pull Request
description: Pull Request Template
title: ""
body:
  - type: markdown
    attributes:
      value: |
        Thank you for contributing to the GitHub Scripts Collection! Please fill out the information below.

  - type: dropdown
    id: pr-type
    attributes:
      label: Type of Change
      description: What type of change does this PR introduce?
      multiple: true
      options:
        - Bug fix (non-breaking change that fixes an issue)
        - New feature (non-breaking change that adds functionality)
        - Breaking change (fix or feature that would cause existing functionality to not work as expected)
        - Documentation update
        - Code refactoring
        - Performance improvement
        - Security fix
    validations:
      required: true

  - type: textarea
    id: description
    attributes:
      label: Description
      description: Please describe your changes in detail
      placeholder: "This PR..."
    validations:
      required: true

  - type: textarea
    id: motivation
    attributes:
      label: Motivation and Context
      description: Why is this change required? What problem does it solve?
      placeholder: "This change is needed because..."

  - type: input
    id: related-issues
    attributes:
      label: Related Issues
      description: Link any related issues (e.g., "Fixes #123" or "Closes #456")
      placeholder: "Fixes #"

  - type: textarea
    id: testing
    attributes:
      label: Testing
      description: Please describe how you tested your changes
      placeholder: |
        - [ ] Tested on macOS
        - [ ] Tested on Linux
        - [ ] Tested with various inputs
        - [ ] Tested error scenarios
    validations:
      required: true

  - type: textarea
    id: screenshots
    attributes:
      label: Screenshots (if applicable)
      description: Add screenshots to help explain your changes
      placeholder: "Paste screenshots here or remove this section if not applicable"

  - type: checkboxes
    id: checklist
    attributes:
      label: Checklist
      description: Please verify all items before submitting
      options:
        - label: My code follows the project's coding standards
          required: true
        - label: I have performed a self-review of my code
          required: true
        - label: I have commented my code, particularly in hard-to-understand areas
          required: true
        - label: I have made corresponding changes to the documentation
          required: false
        - label: My changes generate no new warnings or errors
          required: true
        - label: I have added tests that prove my fix is effective or that my feature works
          required: false
        - label: New and existing unit tests pass locally with my changes
          required: false
        - label: Any dependent changes have been merged and published
          required: false

  - type: textarea
    id: additional-notes
    attributes:
      label: Additional Notes
      description: Any additional information about this PR
      placeholder: "Add any other context about the pull request here"
