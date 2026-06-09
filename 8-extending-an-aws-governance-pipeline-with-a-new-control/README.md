# 8-extending-an-aws-governance-pipeline-with-a-new-control

This directory contains a CloudFormation lab stack, CodeBuild configurations, and CloudFormation Guard policies used to detect risky infrastructure patterns before deployment.

## Directory Tree

```text
8-extending-an-aws-governance-pipeline-with-a-new-control/
├── README.md
├── configuration/
│   ├── buildspec.yml
│   └── buildspec-guard.yml
├── infra/
│   └── template.yml
└── cfn-guard/
    ├── README.md
    ├── iam-no-admin-access-policy.guard
    ├── iam-no-full-access.guard
    ├── iam-no-wildcard-actions.guard
    ├── iam-no-wildcard-resources.guard
    ├── s3-bucket-versioning-enabled.guard
    ├── s3-default-encryption-kms.guard
    ├── s3-no-public-access-guard
    ├── s3-no-wildcard-actions.guard
    ├── s3-no-wildcard-principals.guard
    ├── s3-server-side-encryption-enabled-kms.guard
    ├── security-group-no-allow-all-protocols-ingress.guard
    ├── security-group-no-descriptions.guard
    └── security-group-no-unrestricted-ssh.guard
```

## File Summaries

### Root

- `README.md`: Overview for this lab directory, including folder tree and per-file purpose.

### `configuration/`

- `configuration/buildspec.yml`: CodeBuild spec that installs lint tooling and runs `cfn-lint` against CloudFormation templates in `infra/`.
- `configuration/buildspec-guard.yml`: CodeBuild spec that installs CloudFormation Guard and validates templates in `infra/` using rules from `cfn-guard/`.

### `infra/`

- `infra/template.yml`: Main CloudFormation template that deploys core lab infrastructure (networking, IAM role/profile, EC2 instance, security groups, S3 bucket, and KMS key/alias).

### `cfn-guard/`

- `cfn-guard/README.md`: Rule catalog and local execution guidance for all Guard policies in this folder.
- `cfn-guard/iam-no-admin-access-policy.guard`: Fails IAM roles that attach the AWS managed `AdministratorAccess` policy.
- `cfn-guard/iam-no-full-access.guard`: Fails IAM policies that allow wildcard actions such as `"*"` or `<service>:*`.
- `cfn-guard/iam-no-wildcard-actions.guard`: Fails IAM role permission statements that grant wildcard actions.
- `cfn-guard/iam-no-wildcard-resources.guard`: Fails IAM role/policy statements that allow wildcard resources (`Resource: "*"`).
- `cfn-guard/s3-bucket-versioning-enabled.guard`: Requires S3 buckets to enable versioning (`VersioningConfiguration.Status: Enabled`).
- `cfn-guard/s3-default-encryption-kms.guard`: Requires S3 default encryption to be configured with `SSEAlgorithm: aws:kms`.
- `cfn-guard/s3-no-public-access-guard`: Requires S3 public access block settings to be fully enabled.
- `cfn-guard/s3-no-wildcard-actions.guard`: Prevents IAM managed policies, policies, and role inline policies from using `s3:*`.
- `cfn-guard/s3-no-wildcard-principals.guard`: Prevents S3 bucket policies from allowing wildcard principals (`Principal: "*"`).
- `cfn-guard/s3-server-side-encryption-enabled-kms.guard`: Requires S3 buckets to define encryption and use `aws:kms`.
- `cfn-guard/security-group-no-allow-all-protocols-ingress.guard`: Prevents ingress rules that use `IpProtocol: -1` (all protocols).
- `cfn-guard/security-group-no-descriptions.guard`: Requires descriptions on security group ingress/egress rules.
- `cfn-guard/security-group-no-unrestricted-ssh.guard`: Prevents SSH ingress (`tcp/22`) from being open to the world (`0.0.0.0/0` or `::/0`).
