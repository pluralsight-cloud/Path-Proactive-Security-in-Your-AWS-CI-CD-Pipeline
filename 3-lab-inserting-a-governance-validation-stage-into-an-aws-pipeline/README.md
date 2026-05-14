# Inserting a Governance Validation Stage into an AWS Pipeline

In this lab, you will extend an existing AWS CodePipeline by inserting a dedicated governance validation stage between the Source and Deploy stages.

You will wire the new stage to an AWS CodeBuild project that will serve as the execution engine for future governance checks, then trigger the pipeline to confirm the stage runs as expected.

This establishes the structural foundation used throughout the rest of the path where later labs will add specific compliance checks into the CodeBuild project you wire up here.

These governance patterns let teams **shift security left**, embedding automated policy validation directly into the delivery pipeline rather than relying on manual reviews or post-deployment audits.

## Important Note

**The use of these files requires the Pluralsight hands-on lab environment to successfully deploy.**

## Directory Tree

```text
3-lab-inserting-a-governance-validation-stage-into-an-aws-pipeline/
├── README.md
├── configuration/
│   └── buildspec.yml
└── infra/
    └── template.yml
```

### File Notes

- `README.md`: Lab instructions and command reference.
- `configuration/buildspec.yml`: CodeBuild commands used by the governance stage. Placeholder for now.
- `infra/template.yml`: Sample infrastructure template for deployment flow.

## Before You Begin Important

**You must manually upload `artifacts.zip` to the S3 bucket in order for the pipeline to succeed.**

---

### Bash Commands

Commands used within the lab for easy reference.

#### Zip required files for pipeline change

```shell
zip -r artifacts.zip infra configuration
```
