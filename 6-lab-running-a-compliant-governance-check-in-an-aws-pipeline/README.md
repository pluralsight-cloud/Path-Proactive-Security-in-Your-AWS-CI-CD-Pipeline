# Validating IAM Policies as Automated Unit Tests

This lab serves as the final positive validation test for the entire governance pipeline pattern built in the previous labs.

Learners will push a safe, compliant change to ensure that the integrated checks (*cfn-lint* and *cfn-guard*) successfully pass, allowing the deployment to proceed.

This reinforces the principle that security checks should act like fast, deterministic unit tests.

## Directory Tree

```text
6-lab-running-a-compliant-governance-check-in-an-aws-pipeline/
├── README.md
├── cfn-guard/
│   └── governance-rules.guard
├── configuration/
│   ├── buildspec.yml
│   └── buildspec-guard.yml
└── infra/
    └── template.yml
```

### File Notes

- `README.md`: Lab instructions and command reference.
- `cfn-guard/governance-rules.guard`: Guard rule for mulitple compliance checks.
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
