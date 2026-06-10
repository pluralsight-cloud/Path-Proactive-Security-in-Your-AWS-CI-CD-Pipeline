# Solutions Directory

This directory contains reference solution files for the lab.

- `template.yml` - CloudFormation template that deploys the lab infrastructure and a sample inline Python Lambda function used for secret-scanning and environment variable demonstration.
- `buildspec-secrets.yml` - AWS CodeBuild buildspec that installs and runs TruffleHog to scan repository artifacts for secrets and fail the build when secrets are detected.
