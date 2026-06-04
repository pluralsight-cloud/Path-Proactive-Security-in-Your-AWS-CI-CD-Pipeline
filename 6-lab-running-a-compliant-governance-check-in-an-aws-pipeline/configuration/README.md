# Configuration Directory

This directory contains the CodeBuild specs for lint and governance-rule validation in lab 6.

## File Structure

```text
configuration/
├── buildspec.yml
└── buildspec-guard.yml
```

## File Summaries

- `buildspec.yml`: Installs lint dependencies and runs `cfn-lint` against CloudFormation templates under `infra/`.
- `buildspec-guard.yml`: Installs `cfn-guard` and validates templates in `infra/` against all rules in `cfn-guard/`.
