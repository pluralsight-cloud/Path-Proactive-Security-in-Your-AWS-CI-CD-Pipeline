# Validating IAM Policies as Automated Unit Tests

Learners will build upon the existing governance stage by integrating AWS CloudFormation Guard against overly permissive IAM policies declared in CloudFormation templates.

This lab focuses on ensuring that any proposed CloudFormation templates containing overly permissive or risky IAM policies trigger a pipeline failure, proactively blocking deployment of potentially insecure resources.

## Directory Tree

```text
5-lab-validating-iam-policies-as-automated-unit-tests/
├── README.md
├── cfn-guard/
│   └── iam-no-s3-wildcard.guard
├── configuration/
│   ├── buildspec.yml
│   └── buildspec-guard.yml
└── infra/
    └── template.yml
```

### File Notes

- `README.md`: Lab instructions and command reference.
- `cfn-guard/iam-no-s3-wildcard.guard`: Guard rule to block wildcard S3 IAM actions. Used later on.
- `configuration/buildspec.yml`: CodeBuild commands for governance lint/static analysis.
- `configuration/buildspec-guard.yml`: CodeBuild commands for CloudFormation Guard validation.
- `infra/template.yml`: Sample infrastructure template validated by the pipeline.

### Important

**You must upload `artifacts.zip` to the S3 bucket in order for the pipeline to execute.**

---

## Miscellaneous Resources

### AWS CloudFormation Guard - Documentation

<https://docs.aws.amazon.com/cfn-guard/latest/ug/what-is-guard.html>

### AWS CloudFormation Guard - GitHub

<https://github.com/aws-cloudformation/cloudformation-guard>
