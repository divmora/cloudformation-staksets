# IAM Password Policy StackSet

This directory contains an AWS CloudFormation template (`iam-password-policy.yaml`) that configures and enforces a baseline **IAM Password Policy** across AWS accounts and deploys an **AWS Config Rule** to continuously monitor compliance.

---

## 🎯 Overview & Architecture

When deployed, the template provisions the following resources in the target AWS account:

1. **Custom Resource (`IAMPasswordPolicyCustomResource`)**:
   - Invokes the backing Lambda function on stack creation and update to configure account-level password policy settings via the AWS IAM API (`iam:UpdateAccountPasswordPolicy`).
2. **Lambda Function (`PasswordPolicyFunction`)**:
   - Python 3.12 runtime with embedded logic to execute `update_account_password_policy`.
3. **Execution Role (`LambdaExecutionRole`)**:
   - Scoped IAM role granting the Lambda function permissions for CloudWatch logs (`AWSLambdaBasicExecutionRole`) and IAM password policy updates (`iam:UpdateAccountPasswordPolicy`, `iam:GetAccountPasswordPolicy`).
4. **AWS Config Managed Rule (`IAMPasswordPolicyConfigRule`)**:
   - AWS Config rule based on the AWS-managed identifier `IAM_PASSWORD_POLICY` that monitors compliance against the specified password policy parameters.

```text
┌──────────────────────────────────────────────────────────┐
│                     Target AWS Account                   │
│                                                          │
│  CloudFormation Stack                                    │
│         │                                                │
│         ├─► Custom Resource ──► Lambda Function          │
│         │                          │                     │
│         │                          ▼                     │
│         │                   IAM Password Policy          │
│         │                    (Account Baseline)          │
│         │                                                │
│         └─► AWS Config Rule ─────────▲                   │
│             (Continuous Compliance) ──┘                  │
└──────────────────────────────────────────────────────────┘
```

---

## ⚙️ Template Parameters

| Parameter | Type | Default | Allowed Values | Description |
| :--- | :--- | :--- | :--- | :--- |
| `MinimumPasswordLength` | String | `14` | Any integer $\ge 6$ | Minimum character length for user passwords |
| `RequireUppercaseCharacters` | String | `true` | `true`, `false` | Require at least one uppercase letter (A-Z) |
| `RequireLowercaseCharacters` | String | `true` | `true`, `false` | Require at least one lowercase letter (a-z) |
| `RequireNumbers` | String | `true` | `true`, `false` | Require at least one numeric digit (0-9) |
| `RequireSymbols` | String | `true` | `true`, `false` | Require at least one non-alphanumeric symbol |
| `MaxPasswordAge` | String | `60` | Integer (days, 1-1095) | Number of days before passwords expire |
| `PasswordReusePrevention` | String | `5` | Integer (1-24) | Number of previous passwords to remember |
| `AllowUsersToChangePassword` | String | `true` | `true`, `false` | Allow IAM users to change their own password |
| `HardExpiry` | String | `false` | `true`, `false` | Prevent password reset after password expires without admin intervention |

---

## 🛡️ Control Tower & Security Hub Compliance

Deploying this StackSet satisfies the following **AWS Control Tower** control:

* **`[CONFIG.IAM.DT.1]`**

Enabling this single rule automatically covers and satisfies the requirements for the following **9 related AWS Security Hub controls**, meaning you **do not need to enable them individually**:

| Security Hub Control ID | Title |
| :--- | :--- |
| **`[SH.IAM.7]`** | Password policies for IAM users should have strong configurations |
| **`[SH.IAM.DT.5]`** | Password policies for IAM users should have strong configurations |
| **`[SH.IAM.DT.6]`** | Ensure IAM password policy requires at least one uppercase letter |
| **`[SH.IAM.DT.8]`** | Ensure IAM password policy requires at least one lowercase letter |
| **`[SH.IAM.DT.9]`** | Ensure IAM password policy expires passwords within 90 days or less |
| **`[SH.IAM.DT.10]`** | Ensure IAM password policy requires minimum password length of 14 or greater |
| **`[SH.IAM.DT.12]`** | Ensure IAM password policy prevents password reuse |
| **`[SH.IAM.DT.13]`** | Ensure IAM password policy requires at least one symbol |
| **`[SH.IAM.DT.14]`** | Ensure IAM password policy requires at least one number |

---

## 🚀 Deployment

### Option 1: AWS Management Console (StackSets)

1. Navigate to **CloudFormation** > **StackSets** in your AWS Management or Delegated Administrator account.
2. Select **Create StackSet**.
3. Under **Prerequisite - Prepare template**, select **Template is ready** and upload `iam-password-policy.yaml`.
4. Enter a **StackSet name** (e.g., `IAM-Password-Policy-Baseline`).
5. Adjust parameters to align with your organization's policy baseline.
6. Configure deployment options:
   - **Permission model**: *Service-managed permissions* (for AWS Organizations)
   - **Deployment targets**: Target specific OUs (e.g., Core, Workloads) or the entire Organization.
   - **Specify regions**: Deploy to your home region (e.g., `us-east-1` or `eu-west-1`). Since IAM is a global service, this template only needs to be deployed to a single region per account.
7. Acknowledge IAM capabilities (`CAPABILITY_NAMED_IAM`) and click **Submit**.

---

### Option 2: AWS CLI

#### 1. Create the StackSet
```bash
aws cloudformation create-stack-set \
  --stack-set-name iam-password-policy \
  --template-body file://iam-password-policy.yaml \
  --permission-model SERVICE_MANAGED \
  --auto-deployment Enabled=true,RetainStacksOnAccountRemoval=false \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
      ParameterKey=MinimumPasswordLength,ParameterValue=14 \
      ParameterKey=MaxPasswordAge,ParameterValue=60 \
      ParameterKey=PasswordReusePrevention,ParameterValue=5
```

#### 2. Create Stack Instances across Organizational Units (OUs)
```bash
aws cloudformation create-stack-instances \
  --stack-set-name iam-password-policy \
  --deployment-targets OrganizationalUnitIds="ou-xxxx-xxxxxxxx" \
  --regions "us-east-1" \
  --operation-preferences FailureToleranceCount=0,MaxConcurrentCount=10
```

---

## 🔍 Verification

After stack instance creation completes:

1. **Verify IAM Password Policy in Target Account**:
   ```bash
   aws iam get-account-password-policy
   ```
2. **Verify AWS Config Rule Compliance**:
   ```bash
   aws configservice get-compliance-details-by-config-rule \
     --config-rule-name iam-password-policy
   ```
