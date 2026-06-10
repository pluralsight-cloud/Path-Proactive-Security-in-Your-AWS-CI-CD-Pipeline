# Configuration Directory

This directory contains CodeBuild specs for linting, policy validation, and secrets scanning for lab 8.

## File Structure

```text
configuration/
├── buildspec.yml
├── buildspec-guard.yml
├── buildspec-secrets.yml
└── README.md
```

## File Summaries

- `buildspec.yml`: Installs and runs `cfn-lint` against templates in `infra/` as the static analysis stage.
- `buildspec-guard.yml`: Installs `cfn-guard` and validates all templates in `infra/` against governance rules in `cfn-guard/`.
- `buildspec-secrets.yml`: Starter placeholder for the secrets-scanning buildspec that guides implementing TruffleHog-based scanning steps.
- `README.md`: Describes the configuration directory structure and the role of each buildspec file.
