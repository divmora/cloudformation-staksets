# Contributing to AWS CloudFormation StackSets

Thank you for your interest in contributing to **AWS CloudFormation StackSets**! We welcome new StackSet templates, bug fixes, documentation improvements, and compliance control mappings.

Please review this guide before submitting issues or pull requests.

---

## Code of Conduct

This project adheres to the Contributor Covenant [Code of Conduct](https://github.com/divmora/.github/blob/main/CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

---

## Getting Started

### Prerequisites

Ensure you have the following tools installed on your development machine:
- **AWS CLI v2**: [aws.amazon.com/cli](https://aws.amazon.com/cli/) (configured with appropriate AWS credentials)
- **Python 3.12+**: For custom resource Lambda functions and linting tools
- **Make**: Standard build automation tool
- **cfn-lint**: CloudFormation Linter (`pip install cfn-lint`)
- **yamllint**: YAML Linter (`pip install yamllint`)

### Development Setup

1. **Fork and clone the repository:**
   ```bash
   git clone https://github.com/<your-username>/cloudformation-staksets.git
   cd cloudformation-staksets
   ```

2. **Lint and validate templates:**
   ```bash
   make lint
   make validate
   ```

---

## Development Workflow

### Adding a New StackSet Template

When adding a new StackSet template:
1. Create a dedicated directory (e.g., `s3-public-access-block/`).
2. Add the CloudFormation template YAML file with clear parameters, descriptions, and least-privilege IAM policies.
3. Add a dedicated `README.md` inside the template directory detailing:
   - Architecture diagram / flow
   - Parameter reference table
   - Control Tower and Security Hub compliance mapping
   - AWS Console & CLI deployment instructions
   - Verification commands
4. Update the root [README.md](README.md) table under **Available StackSets**.

### Available Make Targets

- `make lint` - Runs `cfn-lint` and `yamllint` across all template files
- `make validate` - Validates template syntax with the AWS CLI
- `make test` - Runs linting and validation
- `make clean` - Cleans temporary test and build artifacts

---

## Conventional Commits

This project uses [Release Please](https://github.com/googleapis/release-please) to automate semantic versioning and changelog generation. All commit messages and Pull Request titles **must** adhere to the [Conventional Commits](https://www.conventionalcommits.org/) specification.

### Format
```
<type>(<optional scope>): <description>
```

### Common Types
- `feat:` A new StackSet template or major feature (triggers minor version bump)
- `fix:` A bug fix or compliance policy correction (triggers patch version bump)
- `docs:` Documentation improvements
- `refactor:` Template refactoring without functional changes
- `test:` Adding or updating tests / validation
- `chore:` Tooling, CI/CD, or repository maintenance

---

## Submitting Pull Requests

1. Create a descriptive branch from `main`:
   ```bash
   git checkout -b feat/add-s3-public-access-block
   ```
2. Make your template and documentation changes.
3. Validate your changes locally:
   ```bash
   make lint
   ```
4. Commit your changes using Conventional Commits:
   ```bash
   git commit -m "feat(s3): add organization-wide s3 public access block stackset"
   ```
5. Push to your fork and open a Pull Request against `main`.
6. Ensure all CI validation checks pass.

---

## Licensing & Contributor Terms

By submitting a pull request, you agree that your contributions will be licensed under the project's [Apache License 2.0](LICENSE), permitting unrestricted open-source and commercial use.
