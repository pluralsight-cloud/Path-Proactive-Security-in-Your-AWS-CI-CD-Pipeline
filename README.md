# Proactive Security in Your AWS CI/CD Pipeline

An evolution path that teaches practitioners how to shift security left by embedding automated governance controls directly into AWS CI/CD pipelines. Learners build a repeatable governance pattern using CodePipeline, CodeBuild, cfn-lint, and IAM Access Analyzer — then validate it against both compliant and non-compliant deployments.

At the end of it all, learners will challenge themselves by adding their own compliance check within the pipeline to verify a compliant deployment.

## Path Structure

### Course 1: Shifting Left in AWS CI/CD

Foundational course covering the *why* behind pipeline-integrated governance. No hands-on labs — this is purely conceptual preparation.

- **The Shift-Left Mindset** — Motivations for moving security controls earlier in delivery. Guardrails as an extension of CI, not a blocker.
- **Treating Security Findings Like Unit Tests** — Governance checks should be fast, deterministic, and built into the pipeline execution path.

### Course 2: Implement Governance Patterns in an AWS CI/CD Pipeline

Hands-on course where learners build and validate a governance stage inside CodePipeline.

#### Module 1: The Governance Pattern

| Asset | Type | Duration (*Estimated*) | Description |
|-------|------|----------|-------------|
| Governance Pattern Essentials | Clip | 5 min | Architectural overview of the governance stage: inspect, evaluate, block. |
| Build the Governance Stage | Lab | 15 min | Insert a governance stage into an existing CodePipeline backed by a CodeBuild validation project. |
| Add Static Analysis with cfn-lint | Lab | 15 min | Integrate cfn-lint to catch CloudFormation template issues before deployment. |
| Add IAM Validation with Access Analyzer | Lab | 15 min | Validate IAM policies in the pipeline and fail on overly permissive configurations. |
| Interpreting Governance Feedback | Clip | 3 min | Reading pass/fail signals in build logs; reframing failures as successful safeguards. |
| Deploy a Compliant Change | Lab | 15 min | Push a clean resource change and confirm end-to-end pipeline success. |
| Deploy a Non-Compliant Change | Lab | 15 min | Push an intentionally unsafe change and verify the governance stage blocks it. |

#### Module 2: Challenge Lab

| Asset | Type | Duration (*Estimated*) | Description |
|-------|------|----------|-------------|
| Extending the Governance Pipeline with a New Control | Challenge Lab | 30 min | Add one additional automated control using the same services and architectural footprint from Module 1. |

## How It All Fits Together

Course 1 establishes the mental model: governance belongs in the pipeline, and security checks should behave like tests.

Course 2 makes that concrete — learners progressively build a governance stage, layer in validation tools, and prove the pattern works in both pass and fail scenarios. The challenge lab reinforces depth over breadth by extending the same pattern with one more control.

## Repository Layout

| **Each directory maps to either an individual course or a hands-on lab.**

```
├── 1-course-shifting-left-in-aws-ci-cd/                                   # Course 1 assets
├── 2-course-implement-governance-patterns-in-an-aws-ci-cd-pipeline/       # Course 2 assets
├── 3-lab-inserting-a-governance-validation-stage-into-an-aws-pipeline/
│   ├── configuration/
│   │   └── buildspec.yml
│   ├── infra/
│   │   └── template.yml
│   └── README.md
├── 4-lab-using-static-analysis-to-detect-cloudformation-misconfigurations/ # Lab assets
├── 5-lab-validating-iam-policies-as-automated-unit-tests/                  # Lab assets
├── 6-lab-running-a-compliant-governance-check-in-an-aws-pipeline/          # Lab assets
├── 7-lab-failing-a-risky-deployment-through-governance-controls/           # Lab assets
├── 8-extending-an-aws-governance-pipeline-with-a-new-control/              # Challenge lab assets
└── README.md
```
