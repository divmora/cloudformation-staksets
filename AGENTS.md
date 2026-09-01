# Agent Guidelines for AWS CloudFormation StackSets

Welcome to the workspace-specific agent guidelines. These instructions apply to AI agents and developers working on the `cloudformation-staksets` codebase.

---

## 1. Project Architecture & Layout

This repository contains multi-account AWS CloudFormation StackSet templates and governance automations for AWS Organizations and AWS Control Tower:

```
cloudformation-staksets/
├── LICENSE                       # Apache License 2.0
├── README.md                     # Organization catalog & deployment guide
├── AGENTS.md                     # AI agent and development guidelines
├── CONTRIBUTING.md               # Contribution workflow and conventional commits
├── SECURITY.md                   # Security reporting and vulnerability disclosure
├── Makefile                      # Validation and linting automation
├── .gitignore                    # Python & CloudFormation ignore rules
├── .release-please-config.json   # Release Please configuration
├── .release-please-manifest.json # Semantic version tracking
├── .github/
│   ├── dependabot.yml            # Automated GitHub Actions updates
│   └── workflows/
│       ├── ci.yml                # Linting and template validation
│       ├── release-please.yml    # Automated changelog and releases
│       └── semantic-pull-request.yml # Conventional commit PR title linting
└── iam-password-policy/
    ├── README.md                 # Architecture, parameters, and compliance mappings
    └── iam-password-policy.yaml  # CloudFormation template with Lambda custom resource & Config Rule
```

---

## 2. Core Engineering Principles & Safety

### Cloud Mutating Safety & Dry-Run
- **Multi-Account Impact:** CloudFormation StackSets deploy across many AWS accounts and regions simultaneously. Always test template changes against an isolated development OU or test account first.
- **Auto-Deployment Safety:** When configuring auto-deployment (`--auto-deployment Enabled=true`), carefully consider `RetainStacksOnAccountRemoval` settings to prevent orphaned compliance resources or unintended deletions.
- **Concurrency & Failure Tolerance:** Recommended operation preferences when deploying or updating StackSets:
  ```bash
  --operation-preferences FailureToleranceCount=0,MaxConcurrentCount=10
  ```

### Custom Resource Lambda Guidelines
- When implementing CloudFormation custom resources:
  - Always use supported modern runtimes (`python3.12` or later).
  - Wrap all API interactions in `try...except` blocks and guarantee sending a `cfnresponse.send(event, context, cfnresponse.FAILED, {})` response on exceptions to prevent CloudFormation stack creation timeouts.
  - Enforce least-privilege IAM roles for Lambda execution roles (`iam:UpdateAccountPasswordPolicy`, `iam:GetAccountPasswordPolicy`, etc.).

---

## 3. Conventional Commits & Versioning

This project strictly follows the [Conventional Commits](https://www.conventionalcommits.org/) specification with automated releases managed via Release Please.
- `feat:` New StackSet template or feature (triggers minor version bump)
- `fix:` Fixes to existing templates or policies (triggers patch version bump)
- `docs:`, `chore:`, `refactor:`, `test:`

---

## 4. Verification Commands

Before submitting any changes, verify template validity and formatting:
```bash
make lint
```
Or directly:
```bash
cfn-lint **/*.yaml
yamllint .
```
