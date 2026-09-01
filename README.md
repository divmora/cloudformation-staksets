# AWS CloudFormation StackSets

[![Latest Release](https://img.shields.io/github/v/release/divmora/cloudformation-staksets?logo=github)](https://github.com/divmora/cloudformation-staksets/releases)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![CI/CD](https://github.com/divmora/cloudformation-staksets/actions/workflows/ci.yml/badge.svg)](https://github.com/divmora/cloudformation-staksets/actions)
[![Security Policy](https://img.shields.io/badge/Security-Policy-green.svg)](SECURITY.md)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/divmora/cloudformation-staksets)

A curated collection of AWS CloudFormation StackSet templates designed for multi-account governance, security baseline enforcement, and compliance automation across AWS Organizations and AWS Control Tower.

---

## 📁 Repository Structure

```text
.
├── LICENSE                       # Apache License 2.0
├── README.md                     # Repository catalog & overview
├── AGENTS.md                     # Agent guidelines & safety standards
├── CONTRIBUTING.md               # Contribution workflow & conventional commits
├── SECURITY.md                   # Vulnerability disclosure policy
├── Makefile                      # Validation and linting targets
├── .release-please-config.json   # Release Please configuration
├── .release-please-manifest.json # Semantic version tracking
├── .github/
│   ├── dependabot.yml            # Automated GitHub Actions updates
│   └── workflows/
│       ├── ci.yml                # Template linting & validation CI
│       ├── release-please.yml    # Automated versioning and changelog
│       └── semantic-pull-request.yml # PR title validation
└── iam-password-policy/
    ├── README.md                 # Architecture, parameters & compliance mapping
    └── iam-password-policy.yaml  # CloudFormation template
```

---

## 📦 Available StackSets

| StackSet | Description | Key Services | Compliance / Controls |
| :--- | :--- | :--- | :--- |
| [**IAM Password Policy**](./iam-password-policy/README.md) | Enforces account-level IAM password policy requirements and deploys an AWS Config rule for continuous compliance monitoring. | IAM, Lambda, AWS Config | Control Tower `CONFIG.IAM.DT.1`, Security Hub `SH.IAM.*` |

---

## 🚀 Prerequisites & Permissions

Before deploying these templates as CloudFormation StackSets:

1. **AWS Organizations**:
   - AWS Organizations must be configured with **All features** enabled.
2. **CloudFormation StackSets Permissions**:
   - **Service-Managed Permissions (Recommended)**: Enable trusted access with AWS Organizations in CloudFormation to allow deployment to Organizational Units (OUs) without manually configuring IAM roles in target accounts.
   - **Self-Managed Permissions**: If deploying outside of AWS Organizations trusted access, ensure `AWSCloudFormationStackSetAdministrationRole` in the admin account and `AWSCloudFormationStackSetExecutionRole` in target accounts are configured.
3. **AWS Config**:
   - For StackSets that deploy AWS Config rules (such as `iam-password-policy`), ensure AWS Config configuration recorder and delivery channels are enabled in target accounts and regions.

---

## 🛠️ Deployment Instructions

You can deploy any template in this repository using either the AWS Management Console or the AWS CLI.

### Option 1: AWS Management Console

1. Log into your **AWS Management Account** or **Delegated Administrator Account**.
2. Navigate to **AWS CloudFormation** > **StackSets**.
3. Click **Create StackSet**.
4. Choose **Template is ready** and upload the corresponding `.yaml` template file.
5. Specify:
   - **StackSet name**: e.g., `IAM-Password-Policy-Baseline`
   - **Parameters**: Adjust parameters according to your organization's security baseline.
6. Configure deployment options:
   - **Permission model**: Choose *Service-managed permissions* (recommended for AWS Organizations) or *Self-managed permissions*.
   - **Deployment targets**: Deploy to your entire Organization or specific Organizational Units (OUs).
   - **Specify regions**: Select the target AWS region (e.g., `us-east-1` for global IAM resources).
   - **Deployment options**: Set concurrency and failure tolerance preferences.
7. Review and select **Submit**.

---

### Option 2: AWS CLI

Example deployment using Service-Managed Permissions across an Organizational Unit:

```bash
# 1. Create the StackSet
aws cloudformation create-stack-set \
  --stack-set-name iam-password-policy \
  --template-body file://iam-password-policy/iam-password-policy.yaml \
  --permission-model SERVICE_MANAGED \
  --auto-deployment Enabled=true,RetainStacksOnAccountRemoval=false \
  --capabilities CAPABILITY_NAMED_IAM

# 2. Deploy Stack Instances to target Organizational Units (OUs)
aws cloudformation create-stack-instances \
  --stack-set-name iam-password-policy \
  --deployment-targets OrganizationalUnitIds="ou-xxxx-xxxxxxxx" \
  --regions "us-east-1" \
  --operation-preferences FailureToleranceCount=0,MaxConcurrentCount=10
```

---

## 💻 Development & Validation

This project provides standard `make` targets to lint and validate CloudFormation templates locally:

```bash
# Validate template syntax and check CLI availability
make validate

# Lint YAML syntax
make lint

# Run all verification checks
make test

# Clean temporary build/test artifacts
make clean
```

---

## 🤝 Community & Contributing

We welcome community contributions, additional StackSet templates, and compliance enhancements!

- **Contributing Guide**: Please review [CONTRIBUTING.md](CONTRIBUTING.md) for details on our workflow, pull request guidelines, and conventional commits.
- **Code of Conduct**: This project follows the [DIVMORA Technologies Code of Conduct](https://github.com/divmora/.github/blob/main/CODE_OF_CONDUCT.md).
- **Security**: For vulnerability reporting, please review our [Security Policy](SECURITY.md) or email **security@divmora.com**.

---

## 📄 License

This repository is licensed under the **Apache License 2.0**. See the [LICENSE](LICENSE) file for details. You are free to use, modify, and deploy these templates in any commercial, enterprise, or personal environment without fees or commercial restrictions.
