# Configuration Directory

This directory contains CodeBuild specs for linting and Guard validation in lab 7.

## File Structure

```text
configuration/
├── buildspec.yml
└── buildspec-guard.yml
```

## File Summaries

- `buildspec.yml`: Installs and runs `cfn-lint` against templates in `infra/` as the static analysis stage.
- `buildspec-guard.yml`: Installs `cfn-guard` and validates all templates in `infra/` against governance rules in `cfn-guard/`.
