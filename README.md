# Proactive Security in Your AWS CI/CD Pipeline

An evolution path that teaches practitioners how to shift security left by embedding automated governance controls directly into AWS CI/CD pipelines. Learners build a repeatable governance pattern using CodePipeline, CodeBuild, cfn-lint, and cfn-guard. They then validate it against both compliant and non-compliant deployments.

At the end of it all, learners will challenge themselves by adding their own compliance check within the pipeline to verify a compliant deployment.

## Path Structure

| Name | Type | Duration (*Estimated*) | Description |
|-------|------|----------|-------------|
| Shifting Left in AWS CI/CD | Clip | 30 min | Explores the necessity of embedding governance controls into your delivery pipelines. |
| Implement Governance Patterns in an AWS CI/CD Pipeline | Clip | 30 min | Guides you through the practical steps of embedding automated security checks into your deployment process. |
| Inserting a Governance Validation Stage into an AWS Pipeline | Lab | 30 min | Insert a governance stage into an existing CodePipeline backed by a CodeBuild validation project. |
| Using Static Analysis to Detect CloudFormation Misconfigurations | Lab | 30 min | Integrate *cfn-lint* to catch CloudFormation template issues before deployment. |
| Validating IAM Policies as Automated Unit Tests | Lab | 30 min | Validate IAM policies in the pipeline and fail on overly permissive configurations using *cfn-guard*. |
| Running a Compliant Governance Check in an AWS Pipeline | Lab | 30 min | Reading pass/fail signals in build logs; reframing failures as successful safeguards. |
| Failing a Risky Deployment Through Governance Controls | Lab | 30 min | Push a clean resource change and confirm end-to-end pipeline success. |
| Extending an AWS Governance Pipeline with a New Control | Graded Lab | 60 min | Requires learners to apply the repeatable governance pattern they built by implementing an additional automated control into the existing validation stage. |

## How It All Fits Together

Course 1 establishes the mental model: governance belongs in the pipeline, and security checks should behave like tests.

Course 2 makes that concrete, where learners progressively explore the idea of building a governance stage, layering in validation tools, and proving the pattern works in both pass and fail scenarios.

The hands-on labs reinforce depth over breadth by extending the same pattern with one more control.

## Repository Information

**Each directory maps to either an individual course or a hands-on lab.**
**If a directory does not exist, there are no assets for it.**

### Repository Layout

```text
├── .gitignore
├── .pre-commit-config.yaml
├── 3-lab-inserting-a-governance-validation-stage-into-an-aws-pipeline/
│   ├── configuration/
│   │   ├── README.md
│   │   └── buildspec.yml
│   ├── infra/
│   │   ├── README.md
│   │   └── template.yml
│   └── README.md
├── 4-lab-using-static-analysis-to-detect-cloudformation-misconfigurations/
│   ├── BAD_TEMPLATE_EXAMPLE.yml
│   ├── configuration/
│   │   ├── README.md
│   │   └── buildspec.yml
│   ├── infra/
│   │   ├── README.md
│   │   └── template.yml
│   ├── README.md
│   └── requirements.txt
├── 5-lab-validating-iam-policies-as-automated-unit-tests/
│   ├── cfn-guard/
│   │   ├── README.md
│   │   └── iam-no-s3-wildcard.guard
│   ├── configuration/
│   │   ├── README.md
│   │   ├── buildspec-guard.yml
│   │   └── buildspec.yml
│   ├── infra/
│   │   ├── README.md
│   │   └── template.yml
│   └── README.md
├── 6-lab-running-a-compliant-governance-check-in-an-aws-pipeline/
│   ├── cfn-guard/
│   │   ├── README.md
│   │   ├── iam-no-admin-access-policy.guard
│   │   ├── iam-no-wildcard-resources.guard
│   │   ├── s3-no-public-access-guard
│   │   ├── s3-no-wildcard-actions.guard
│   │   ├── s3-no-wildcard-principals.guard
│   │   ├── s3-server-side-encryption-enabled.guard
│   │   ├── security-group-no-allow-all-protocols.guard
│   │   ├── security-group-no-descriptions.guard
│   │   └── security-group-no-unrestricted-ssh.guard
│   ├── configuration/
│   │   ├── README.md
│   │   ├── buildspec-guard.yml
│   │   └── buildspec.yml
│   ├── infra/
│   │   ├── README.md
│   │   └── template.yml
│   └── README.md
├── 7-lab-failing-a-risky-deployment-through-governance-controls/
│   ├── cfn-guard/
│   │   ├── README.md
│   │   ├── iam-no-admin-access-policy.guard
│   │   ├── iam-no-full-access.guard
│   │   ├── iam-no-wildcard-actions.guard
│   │   ├── iam-no-wildcard-resources.guard
│   │   ├── s3-bucket-versioning-enabled.guard
│   │   ├── s3-default-encryption-kms.guard
│   │   ├── s3-no-public-access-guard
│   │   ├── s3-no-wildcard-actions.guard
│   │   ├── s3-no-wildcard-principals.guard
│   │   ├── s3-server-side-encryption-enabled-kms.guard
│   │   ├── security-group-no-allow-all-protocols-ingress.guard
│   │   ├── security-group-no-descriptions.guard
│   │   └── security-group-no-unrestricted-ssh.guard
│   ├── configuration/
│   │   ├── README.md
│   │   ├── buildspec-guard.yml
│   │   └── buildspec.yml
│   ├── infra/
│   │   ├── README.md
│   │   └── template.yml
│   └── README.md
├── README.md
└── requirements.txt
```

## Lab Progression Pyramid

Each lab builds on the previous lab throughout this path.

```text
            ___________________________________________________________
           /     Shifting Left in AWS CI/CD Pipelines Accomplished     \
          /-------------------------------------------------------------\
         /  Lab: Failing a Risky Deployment Through Governance Controls  \
        /-----------------------------------------------------------------\
       /    Lab: Running a Compliant Governance Check in an AWS Pipeline   \
      /---------------------------------------------------------------------\
     /        Lab: Validating IAM Policies as Automated Unit Tests           \
    /-------------------------------------------------------------------------\
   /   Lab: Using Static Analysis to Detect CloudFormation Misconfigurations   \
  /-----------------------------------------------------------------------------\
 /      Lab: Inserting a Governance Validation Stage into an AWS Pipeline        \
/---------------------------------------------------------------------------------\
```
