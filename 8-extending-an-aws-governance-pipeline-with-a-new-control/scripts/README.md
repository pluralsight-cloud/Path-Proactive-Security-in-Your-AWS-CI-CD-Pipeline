# Scripts Directory

This directory contains helper scripts used by the lab workflow.

- `run_me.sh` - Creates (or reuses) IAM access keys, parses values from `access-keys.txt`, injects them into `infra/template.yml` placeholders, and removes the temporary keys file after updating.
