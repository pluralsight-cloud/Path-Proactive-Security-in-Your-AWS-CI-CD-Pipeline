# CloudFormation Guard Rules

This directory contains the CloudFormation Guard (`cfn-guard`) policy files used to
validate `infra/template.yml` before deployment.

## Important

`WARNING`: This directory directly explains each individual Guard policy within it. If you need help understanding what each one does, you can use this as a reference. If you want to try and find out what each one does on its own, save this file for only when you **need** it.

## Files in this directory

### `iam-no-admin-access-policy.guard`

- **Rule identifier:** `IAM_ROLE_ADMINISTRATOR_ACCESS_POLICY_RULE`
- **Checks:** IAM roles do not attach the AWS managed
  `arn:aws:iam::aws:policy/AdministratorAccess` policy.
- **Resources:** `AWS::IAM::Role`

### `iam-no-wildcard-resources.guard`

- **Rule identifier:** `IAM_POLICYDOCUMENT_NO_WILDCARD_RESOURCE`
- **Checks:** IAM role/policy/managed policy statements do not allow `Resource: "*"`
  with `Effect: "Allow"`.
- **Resources:** `AWS::IAM::Role`, `AWS::IAM::Policy`, `AWS::IAM::ManagedPolicy`

### `s3-no-public-access-guard`

- **Rule identifier:** `S3_BUCKET_LEVEL_PUBLIC_ACCESS_PROHIBITED`
- **Checks:** S3 buckets define `PublicAccessBlockConfiguration` and set all four
  public access controls to `true`.
- **Resources:** `AWS::S3::Bucket`

### `s3-no-wildcard-actions.guard`

- **Rule identifiers:** `iam_managed_policy_disallow_s3_wildcard`,
  `iam_policy_disallow_s3_wildcard`, `iam_role_inline_policy_disallow_s3_wildcard`
- **Checks:** IAM policy statements do not include `Action: "s3:*"`.
- **Resources:** `AWS::IAM::ManagedPolicy`, `AWS::IAM::Policy`, `AWS::IAM::Role`

### `s3-no-wildcard-principals.guard`

- **Rule identifier:** `S3_BUCKET_POLICY_NO_WILDCARD_PRINCIPAL`
- **Checks:** S3 bucket policies do not allow wildcard principal (`Principal: "*"`)
  in `Allow` statements.
- **Resources:** `AWS::S3::BucketPolicy`

### `s3-server-side-encryption-enabled.guard`

- **Rule identifier:** `S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED`
- **Checks:** S3 buckets enable default encryption and use `aws:kms` or `AES256`.
- **Resources:** `AWS::S3::Bucket`

### `security-group-no-allow-all-protocols.guard`

- **Rule identifier:** `SECURITY_GROUP_INGRESS_ALL_PROTOCOLS_RULE`
- **Checks:** Security group ingress does not use protocol `-1` (all protocols).
- **Resources:** `AWS::EC2::SecurityGroup`, `AWS::EC2::SecurityGroupIngress`

### `security-group-no-descriptions.guard`

- **Rule identifier:** `SECURITY_GROUP_DESCRIPTION_RULE`
- **Checks:** Security group ingress/egress rules include `Description`.
- **Resources:** `AWS::EC2::SecurityGroup`, `AWS::EC2::SecurityGroupIngress`,
  `AWS::EC2::SecurityGroupEgress`

### `security-group-no-egress-open-to-anywhere.guard`

- **Rule identifier:** `EC2_SECURITY_GROUP_INGRESS_OPEN_TO_WORLD_RULE`
- **Checks:** Security group ingress does not allow `CidrIp: 0.0.0.0/0` or
  `CidrIpv6: ::/0`.
- **Resources:** `AWS::EC2::SecurityGroup`, `AWS::EC2::SecurityGroupIngress`

### `security-group-no-unrestricted-ssh.guard`

- **Rule identifier:** `INCOMING_SSH_DISABLED`
- **Checks:** SSH ingress (`tcp/22`) is not open to `0.0.0.0/0` or `::/0`.
- **Resources:** `AWS::EC2::SecurityGroup`, `AWS::EC2::SecurityGroupIngress`

## Run rules locally

Validate a template against all guard files in this directory:

```bash
cfn-guard validate --rules cfn-guard/ --data infra/template.yml
```

`cfn-guard` exits non-zero when one or more rules fail.
