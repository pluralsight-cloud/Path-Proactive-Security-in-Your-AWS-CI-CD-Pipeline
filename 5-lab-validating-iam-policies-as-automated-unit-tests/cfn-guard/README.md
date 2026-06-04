# CloudFormation Guard Directory

This directory contains Guard rules used to validate IAM policy behavior in lab 5.

## File Structure

```text
cfn-guard/
└── iam-no-s3-wildcard.guard
```

## File Summaries

- `iam-no-s3-wildcard.guard`: Guard policies that fail IAM managed policies, IAM policies, and IAM role inline policies when `Action` includes `s3:*`.
