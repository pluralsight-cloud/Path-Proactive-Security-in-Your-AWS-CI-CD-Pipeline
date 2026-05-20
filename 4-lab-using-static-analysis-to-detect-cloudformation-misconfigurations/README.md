# Using Static Analysis to Detect CloudFormation Misconfigurations

Learn how to enforce governance in your infrastructure-as-code pipeline by integrating the *cfn-lint* tool to detect CloudFormation template issues.

You will configure buildspec commands in a `buildspec.yml` file to run static analysis in the governance stage, identifying template misconfigurations and validating that your pipeline automatically blocks non-compliant templates from being deployed.

## Directory Tree

```text
4-lab-using-static-analysis-to-detect-cloudformation-misconfigurations/
├── README.md
├── BAD_TEMPLATE_EXAMPLE.yml
├── requirements.txt
├── configuration/
│   └── buildspec.yml
└── infra/
    └── template.yml
```

### File Notes

- `README.md`: Lab instructions and command reference.
- `BAD_TEMPLATE_EXAMPLE.yml`: A misconfigured template to locally validate *cfn-lint* against a file with bad syntax.
- `requirements.txt`: Required Python packages for cfn-lint to function work.
- `configuration/buildspec.yml`: CodeBuild commands used by the governance stage. Adds in *cfn-lint* to the CI/CD flow.
- `infra/template.yml`: Sample infrastructure template for deployment flow. Contains template syntax for sample resources

## Important

**You must manually upload `artifacts.zip` to the S3 bucket in order for the pipeline to succeed.**
