# Configuration Directory

This directory contains CodeBuild specs for template linting and Guard-based IAM policy checks.

## File Structure

```text
configuration/
├── buildspec.yml
└── buildspec-guard.yml
```

## File Summaries

- `buildspec.yml`: Installs Python lint tooling and runs `cfn-lint` over templates in `infra/`.
- `buildspec-guard.yml`: Installs CloudFormation Guard and validates `infra/template.yml` against `cfn-guard/iam-no-s3-wildcard.guard`.
