# CloudFormation Guard Governance Rules

**WARNING** - This document explains all of the rules defined within the cfn-guard file. If you want to explore them and try to figure them out yourself, it is recommended you do not read this right away.

---

## Directory explanation

This directory contains the policy-as-code rules that the governance pipeline runs
against CloudFormation templates **before** they are deployed. All rules live in a
single file, [`governance-rules.guard`](./governance-rules.guard), written in the
[AWS CloudFormation Guard](https://github.com/aws-cloudformation/cloudformation-guard)
(`cfn-guard`) domain-specific language.

During the pipeline's `GovernanceGuard` stage, the rules are evaluated by
[`../configuration/buildspec-guard.yml`](../configuration/buildspec-guard.yml) with:

```bash
cfn-guard validate --rules cfn-guard/governance-rules.guard --data infra/template.yml
```

If any rule fails, `cfn-guard` exits non-zero, which fails the build and stops the
template from reaching the `Deploy` stage.

## Rules at a glance

| Rule | Guards against | Resource types | CFN_NAG ID |
| --- | --- | --- | --- |
| `IAM_ROLE_NO_WILDCARD_ACTIONS_ON_PERMISSIONS` | IAM roles granting `*` / `<service>:*` actions | `AWS::IAM::Role` | F3 |
| `INCOMING_SSH_DISABLED` | SSH (port 22) open to the world | `AWS::EC2::SecurityGroup` | - |
| `iam_managed_policy_disallow_s3_wildcard` | `s3:*` in managed policies | `AWS::IAM::ManagedPolicy` | - |
| `iam_policy_disallow_s3_wildcard` | `s3:*` in standalone policies | `AWS::IAM::Policy` | - |
| `iam_role_inline_policy_disallow_s3_wildcard` | `s3:*` in inline role policies | `AWS::IAM::Role` | - |
| `SECURITY_GROUP_INGRESS_ALL_PROTOCOLS_RULE` | Ingress allowing all protocols (`-1`) | `AWS::EC2::SecurityGroup`, `AWS::EC2::SecurityGroupIngress` | W42 |
| `SECURITY_GROUP_DESCRIPTION_RULE` | Security group rules without a description | `AWS::EC2::SecurityGroup{,Ingress,Egress}` | W36 |

## How the rules work

Each rule follows the same three-part shape.

### 1. Select the resources of interest

A `let` query collects the matching resources from the template's `Resources`
section into a named variable:

```text
let iam_policies = Resources.*[ Type == "AWS::IAM::Policy" ]
```

`Resources.*` iterates every resource; the `[ ... ]` filter keeps only those whose
`Type` matches. The result is a collection bound to `%iam_policies`.

### 2. Only run when there is something to check (SKIP)

Rules are gated with a `when %var !empty` clause:

```text
rule iam_policy_disallow_s3_wildcard when %iam_policies !empty {
  ...
}
```

If the selection is empty (the template has no resources of that type), the rule is
**SKIPPED** rather than failing. This keeps the rules reusable across templates that
do not contain every resource type.

### 3. Assert the desired condition (PASS / FAIL)

Inside the block, the rule walks into the matched resources and asserts a condition.
For example, every statement's `Action` must not be the S3 wildcard:

```text
Properties.PolicyDocument.Statement[*] {
  Action != "s3:*"
  Action[*] != "s3:*"
}
```

The two lines cover both shapes that `Action` can take in a policy statement: a single
string (`Action: "s3:*"`) and a list (`Action: ["s3:*", ...]`). If every selected
resource satisfies the assertion the rule **PASSES**; if any resource violates it the
rule **FAILS** and (where defined) prints a `<< Violation / Fix >>` message.

### Suppression metadata

Several rules can be intentionally skipped per-resource via template `Metadata`. Each
of these rules adds two extra filters to its selector so that suppressed resources are
excluded from the check:

```text
Metadata.cfn_nag.rules_to_suppress not exists or
Metadata.cfn_nag.rules_to_suppress.*.id != "F3"
Metadata.guard.SuppressedRules not exists or
Metadata.guard.SuppressedRules.* != "IAM_ROLE_NO_WILDCARD_ACTIONS_ON_PERMISSIONS"
```

This means a resource is exempt if its metadata references either the matching
[`cfn_nag`](https://github.com/stelligent/cfn_nag) rule ID (e.g. `F3`, `W42`, `W36`)
or the Guard rule name. See [Suppressing a rule](#suppressing-a-rule) below.

## Rules reference

### `IAM_ROLE_NO_WILDCARD_ACTIONS_ON_PERMISSIONS` (CFN_NAG F3)

- **Reports on:** `AWS::IAM::Role`
- **What it checks:** No IAM role may have a policy statement that `Allow`s the full
  wildcard action `*` or a service-level wildcard such as `s3:*`, `ec2:*`, etc. The
  service-level form is matched with the regex `/^[a-zA-Z0-9]*:\*$/`.
- **Logic:** It builds a `%violations` collection of statements where
  `Effect == "Allow"` and an action matches the wildcard pattern, then asserts
  `%violations empty`.
- **Scenarios:**
  - SKIP: no IAM roles present, or the role suppresses `F3` /
    `IAM_ROLE_NO_WILDCARD_ACTIONS_ON_PERMISSIONS`.
  - PASS: no role allows a full or service wildcard action.
  - FAIL: any role allows `*` or `<service>:*`.
- **Fix:** Remove statements shaped like
  `{"Effect": "Allow", "Action": "<service-name>:*"}` or
  `{"Effect": "Allow", "Action": "*"}` and scope them to specific actions.

### `INCOMING_SSH_DISABLED`

- **Reports on:** `AWS::EC2::SecurityGroup`
- **What it checks:** Security groups that define an SSH ingress (a rule with
  `FromPort == 22`, `ToPort == 22`, `IpProtocol == "tcp"`) must not open it to any IP
  address. The rule fails when an ingress entry exactly equals
  `{CidrIp:"0.0.0.0/0", ToPort:22, FromPort:22, IpProtocol:"tcp"}`.
- **Scenarios:**
  - SKIP: no security groups, no SSH ingress defined, or the group suppresses
    `INCOMING_SSH_DISABLED`.
  - PASS: SSH ingress is restricted to a CIDR other than `0.0.0.0/0`.
  - FAIL: SSH is reachable from `0.0.0.0/0`.
- **Fix:** Set `SecurityGroupIngress.CidrIp` to a more restrictive CIDR than
  `0.0.0.0/0`.

### `IAM_NO_S3_WILDCARD_ACTIONS`

This is implemented as three sibling rules so the same `s3:*` check is applied
wherever IAM permissions can be declared. Each rejects both the scalar
(`Action: "s3:*"`) and list (`Action[*]`) forms.

- **`iam_managed_policy_disallow_s3_wildcard`** - reports on `AWS::IAM::ManagedPolicy`;
  checks `Properties.PolicyDocument.Statement[*]`.
- **`iam_policy_disallow_s3_wildcard`** - reports on `AWS::IAM::Policy`; checks
  `Properties.PolicyDocument.Statement[*]`.
- **`iam_role_inline_policy_disallow_s3_wildcard`** - reports on `AWS::IAM::Role`;
  only runs `when Properties.Policies exists`, then checks
  `Properties.Policies[*].PolicyDocument.Statement[*]`.
- **Scenarios:**
  - SKIP: no resources of that type (the role variant also skips when the role has no
    inline `Properties.Policies`).
  - PASS: no statement uses the `s3:*` action.
  - FAIL: any statement uses `s3:*`.
- **Fix:** Replace `s3:*` with the specific S3 actions actually required (for example
  `s3:GetObject`, `s3:PutObject`).

### `SECURITY_GROUP_INGRESS_ALL_PROTOCOLS_RULE` (CFN_NAG W42)

- **Reports on:** `AWS::EC2::SecurityGroup` (inline ingress) and
  `AWS::EC2::SecurityGroupIngress` (standalone).
- **What it checks:** Ingress rules must not use `IpProtocol` of `-1`, which means
  "all protocols". Both the string `'-1'` and the number `-1` are treated as
  violations.
- **Logic:** It collects `%violations_sg` (inline ingress with protocol `-1`) and
  `%violations_sgi` (standalone ingress with protocol `-1`) and asserts both are empty.
- **Scenarios:**
  - SKIP: no security group / ingress resources, or the resource suppresses `W42` /
    `SECURITY_GROUP_INGRESS_ALL_PROTOCOLS_RULE`.
  - PASS: no ingress uses `-1`.
  - FAIL: any ingress uses `-1`.
- **Fix:** Set `IpProtocol` to a specific protocol such as `tcp`, `udp`, `icmp`, or
  `icmpv6`.

### `SECURITY_GROUP_DESCRIPTION_RULE` (CFN_NAG W36)

- **Reports on:** `AWS::EC2::SecurityGroup`, `AWS::EC2::SecurityGroupEgress`, and
  `AWS::EC2::SecurityGroupIngress`.
- **What it checks:** Every ingress/egress rule must include a `Description`.
  Undescribed rules obscure their purpose and make it harder to keep access tightly
  scoped. The rule checks inline `SecurityGroupIngress[*]` / `SecurityGroupEgress[*]`
  entries as well as standalone ingress/egress resources for a missing `Description`.
- **Scenarios:**
  - SKIP: no security group, ingress, or egress resources, or the resource suppresses
    `W36` / `SECURITY_GROUP_DESCRIPTION_RULE`.
  - PASS: all ingress/egress rules have a description.
  - FAIL: any ingress/egress rule is missing a description.
- **Fix:** Add a `Description` to each security group ingress and egress rule.

## Suppressing a rule

To intentionally exempt a specific resource from a rule, add a `Metadata` block to that
resource. Either of the following forms is recognized by the rules' selectors.

Using `cfn_nag` rule IDs:

```yaml
MyResource:
  Type: AWS::IAM::Role
  Metadata:
    cfn_nag:
      rules_to_suppress:
        - id: F3
          reason: Justification for allowing the wildcard here.
  Properties:
    ...
```

Using Guard rule names:

```yaml
MyResource:
  Type: AWS::IAM::Role
  Metadata:
    guard:
      SuppressedRules:
        - IAM_ROLE_NO_WILDCARD_ACTIONS_ON_PERMISSIONS
  Properties:
    ...
```

> Note: Only the rules that include suppression filters in their selectors honor this
> metadata (`IAM_ROLE_NO_WILDCARD_ACTIONS_ON_PERMISSIONS`, `INCOMING_SSH_DISABLED`,
> `SECURITY_GROUP_INGRESS_ALL_PROTOCOLS_RULE`, and `SECURITY_GROUP_DESCRIPTION_RULE`).
> The `s3:*` rules do not currently support suppression.

## Running the rules locally

Install `cfn-guard`, then validate a template against the rules file:

```bash
cfn-guard validate --rules cfn-guard/governance-rules.guard --data infra/template.yml
```

This is the same command the pipeline runs in its `GovernanceGuard` stage via
[`../configuration/buildspec-guard.yml`](../configuration/buildspec-guard.yml). A
non-zero exit code indicates one or more rules failed.
