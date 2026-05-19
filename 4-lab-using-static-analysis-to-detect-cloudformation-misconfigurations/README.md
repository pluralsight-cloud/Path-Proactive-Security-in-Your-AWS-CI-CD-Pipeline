# Using Static Analysis to Detect CloudFormation Misconfigurations

Learn how to enforce governance in your infrastructure-as-code pipeline by integrating the *cfn-lint* tool to detect CloudFormation template issues.

You will configure buildspec commands in a `buildspec.yml` file to run static analysis in the governance stage, identifying template misconfigurations and validating that your pipeline automatically blocks non-compliant templates from being deployed.

## Directory Tree

```text
2-Using Static Analysis to Detect CloudFormation Misconfigurations/
├── README.md
├── configuration/
│   └── buildspec.yml
└── infra/
    └── template.yml
```

### File Notes

- `README.md`: Lab instructions and command reference.
- `configuration/buildspec.yml`: CodeBuild steps for cfn-lint static analysis.
- `infra/template.yml`: Infrastructure template validated during governance checks. You will need to check this.

## Before You Begin Important

**You must manually upload `artifacts.zip` to the S3 bucket in order for the pipeline to succeed.**

---

### Bash Commands

Commands used within the lab for easy reference.

#### Zip required files for pipeline change

Ensure you are in the root directory of the lab and then execute the command below to recursively zip all of the required files into the artifacts zip file.

```shell
zip -r artifacts.zip infra configuration
```
