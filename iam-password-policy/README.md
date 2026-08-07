# IAM Password Policy

This repository contains an AWS CloudFormation template (`iam-password-policy.yaml`) that sets the IAM Password Policy across your AWS accounts and deploys an AWS Config rule to monitor compliance.

## Control Tower Compliance

Deploying this stack helps satisfy the following AWS Control Tower control:

* **[CONFIG.IAM.DT.1]**

By enabling this single rule, it automatically covers and satisfies the requirements for the following 9 related rules, meaning you **do not need to enable them individually**:

* **[SH.IAM.DT.8]** Ensure IAM password policy requires at least one lowercase letter
* **[SH.IAM.DT.9]** Ensure IAM password policy expires passwords within 90 days or less
* **[SH.IAM.7]** Password policies for IAM users should have strong configurations
* **[SH.IAM.DT.10]** Ensure IAM password policy requires minimum password length of 14 or greater
* **[SH.IAM.DT.5]** Password policies for IAM users should have strong configurations
* **[SH.IAM.DT.6]** Ensure IAM password policy requires at least one uppercase letter
* **[SH.IAM.DT.13]** Ensure IAM password policy requires at least one symbol
* **[SH.IAM.DT.12]** Ensure IAM password policy prevents password reuse
* **[SH.IAM.DT.14]** Ensure IAM password policy requires at least one number

## Deployment

You can deploy the `iam-password-policy.yaml` template via CloudFormation StackSets to enforce these password policy settings across multiple accounts in your AWS Organization.
