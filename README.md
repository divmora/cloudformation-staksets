# AWS CloudFormation StackSets

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/divmora/cloudformation-staksets)

A curated collection of AWS CloudFormation StackSet templates designed for multi-account governance, security baseline enforcement, and compliance automation across AWS Organizations and AWS Control Tower.

---

## 📁 Repository Structure

```text
.
├── README.md
└── iam-password-policy/
    ├── README.md
    └── iam-password-policy.yaml
```

---

## 📦 Available StackSets

| StackSet | Description | Key Services | Compliance / Controls |
| :--- | :--- | :--- | :--- |
| [**IAM Password Policy**](./iam-password-policy/README.md) | Enforces account-level IAM password policy requirements and deploys an AWS Config rule for continuous compliance monitoring. | IAM, Lambda, AWS Config | Control Tower `CONFIG.IAM.DT.1`, Security Hub `SH.IAM.*` |

---

## 🚀 Prerequisites

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

## 🤝 Contributing

Contributions to add new baseline StackSets or improve existing templates are welcome:

1. Create a dedicated directory for the StackSet (e.g., `s3-public-access-block/`).
2. Include the CloudFormation template (`.yaml`).
3. Include a comprehensive `README.md` detailing parameters, architecture, compliance mappings, and deployment steps.
4. Submit a pull request.
