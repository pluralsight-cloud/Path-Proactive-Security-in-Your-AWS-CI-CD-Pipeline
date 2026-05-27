# Validating IAM Policies as Automated Unit Tests

Learners will build upon the existing governance stage by integrating AWS CloudFormation Guard against overly permissive IAM policies declared in CloudFormation templates.

This lab focuses on ensuring that any proposed CloudFormation templates containing overly permissive or risky IAM policies trigger a pipeline failure, proactively blocking deployment of potentially insecure resources.

## Directory Tree

```text
3-Validating IAM Policies as Automated Unit Tests/
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

## Before You Begin Important

**You must upload `artifacts.zip` to the S3 bucket in order for the pipeline to succeed.**

---

### Bash Commands

Commands used within the lab for easy reference.

#### Zip required files for pipeline change

Ensure you are in the root directory of the lab and then execute the command below.

```shell
zip -r artifacts.zip infra configuration cfn-guard
```
