# Validating IAM Policies as Automated Unit Tests

This lab serves as the final positive validation test for the entire governance pipeline pattern built in the previous labs.

Learners will push a safe, compliant change to ensure that the integrated checks (*cfn-lint* and *cfn-guard*) successfully pass, allowing the deployment to proceed.

This reinforces the principle that security checks should act like fast, deterministic unit tests.

## Directory Tree

```text
6-lab-running-a-compliant-governance-check-in-an-aws-pipeline/
├── README.md
├── cfn-guard/
│   ├── README.md
│   ├── iam-no-admin-access-policy.guard
│   ├── iam-no-wildcard-resources.guard
│   ├── s3-no-public-access-guard
│   ├── s3-no-wildcard-actions.guard
│   ├── s3-no-wildcard-principals.guard
│   ├── s3-server-side-encryption-enabled.guard
│   ├── security-group-no-allow-all-protocols.guard
│   ├── security-group-no-descriptions.guard
│   └── security-group-no-unrestricted-ssh.guard
├── configuration/
│   ├── buildspec.yml
│   └── buildspec-guard.yml
└── infra/
    └── template.yml
```

### File Notes

- `README.md`: Lab instructions and command reference.
- `cfn-guard/README.md`: Overview of all CloudFormation Guard rules in this directory.
- `cfn-guard/iam-no-admin-access-policy.guard`: Prevents IAM roles from attaching `AdministratorAccess`.
- `cfn-guard/iam-no-wildcard-resources.guard`: Prevents wildcard resources (`Resource: "*"`) in IAM allow statements.
- `cfn-guard/s3-no-public-access-guard`: Ensures S3 buckets enforce all four Public Access Block settings.
- `cfn-guard/s3-no-wildcard-actions.guard`: Prevents wildcard S3 actions (`s3:*`) in IAM policies.
- `cfn-guard/s3-no-wildcard-principals.guard`: Prevents wildcard principals (`Principal: "*"`) in S3 bucket policies.
- `cfn-guard/s3-server-side-encryption-enabled.guard`: Ensures S3 buckets use default encryption (`AES256` or `aws:kms`).
- `cfn-guard/security-group-no-allow-all-protocols.guard`: Prevents ingress rules from using `IpProtocol: -1`.
- `cfn-guard/security-group-no-descriptions.guard`: Ensures security group ingress/egress rules have descriptions.
- `cfn-guard/security-group-no-unrestricted-ssh.guard`: Prevents unrestricted SSH access (`tcp/22`) from `0.0.0.0/0` or `::/0`.
- `configuration/buildspec.yml`: Build commands for static analysis checks.
- `configuration/buildspec-guard.yml`: Build commands for CloudFormation Guard checks.
- `infra/template.yml`: Compliant infrastructure template used for deployment validation.

## Important

**You must upload `artifacts.zip` to the S3 bucket in order for the pipeline to succeed.**

---

## Miscellaneous Resources

### AWS CloudFormation Guard - Documentation

<https://docs.aws.amazon.com/cfn-guard/latest/ug/what-is-guard.html>

### AWS CloudFormation Guard - GitHub

<https://github.com/aws-cloudformation/cloudformation-guard>
