#!/usr/bin/env bash

set -euo pipefail
PS4=':$LINENO+'
set -x

ACCESS_KEYS_FILE="${HOME}/access-keys.txt"
TEMPLATE_FILE="${HOME}/8-extending-an-aws-governance-pipeline-with-a-new-control/infra/template.yml"

ACCESS_KEY_PLACEHOLDER='AWS_ACCESS_KEY_ID: <ACCESS_KEY_ID_PLACEHOLDER>'
SECRET_KEY_PLACEHOLDER='AWS_SECRET_ACCESS_KEY: <SECRET_ACCESS_KEY_PLACEHOLDER>'

run_access_key_command() {
  (
    aws iam create-access-key --user-name cloud_user \
      | jq '."AccessKey" | "AccessKeyId: \(.AccessKeyId), SecretAccessKey: \(.SecretAccessKey)"' \
      > ${HOME}/access-keys.txt
  )
}

extract_labeled_value() {
  local label="$1"
  local line="$2"
  echo "${line}" | sed -E "s/.*${label}:[[:space:]]*([^,]+).*/\1/" | xargs
}

escape_sed_replacement() {
  printf '%s' "$1" | sed -e 's/[&|\\]/\\&/g'
}

parse_access_keys() {
  if [[ ! -f "${ACCESS_KEYS_FILE}" ]]; then
    echo "Error: Could not find file: ${ACCESS_KEYS_FILE}" >&2
    exit 1
  fi

  mapfile -t raw_lines < <(sed -e 's/^"//' -e 's/"$//' "${ACCESS_KEYS_FILE}" | awk 'NF')
  if [[ "${#raw_lines[@]}" -eq 0 ]]; then
    echo "Error: File is empty: ${ACCESS_KEYS_FILE}" >&2
    exit 1
  fi

  ACCESS_KEY_ID=""
  SECRET_ACCESS_KEY=""

  if [[ "${#raw_lines[@]}" -ge 2 ]]; then
    if [[ "${raw_lines[0]}" == *:* ]]; then
      ACCESS_KEY_ID="$(echo "${raw_lines[0]}" | cut -d':' -f2- | xargs)"
    else
      ACCESS_KEY_ID="$(echo "${raw_lines[0]}" | xargs)"
    fi

    if [[ "${raw_lines[1]}" == *:* ]]; then
      SECRET_ACCESS_KEY="$(echo "${raw_lines[1]}" | cut -d':' -f2- | xargs)"
    else
      SECRET_ACCESS_KEY="$(echo "${raw_lines[1]}" | xargs)"
    fi
  else
    ACCESS_KEY_ID="$(extract_labeled_value "AccessKeyId" "${raw_lines[0]}")"
    SECRET_ACCESS_KEY="$(extract_labeled_value "SecretAccessKey" "${raw_lines[0]}")"
  fi

  if [[ -z "${ACCESS_KEY_ID}" || -z "${SECRET_ACCESS_KEY}" ]]; then
    echo "Error: Unable to parse access key values from access-keys.txt." >&2
    echo "Expected either two lines or one line with AccessKeyId and SecretAccessKey labels." >&2
    exit 1
  fi
}

replace_template_values() {
  if [[ ! -f "${TEMPLATE_FILE}" ]]; then
    echo "Error: Could not find file: ${TEMPLATE_FILE}" >&2
    exit 1
  fi

  if ! grep -Eq "AWS_ACCESS_KEY_ID:[[:space:]]*<ACCESS_KEY_ID_PLACEHOLDER>" "${TEMPLATE_FILE}"; then
    echo "Error: Missing placeholder in template: ${ACCESS_KEY_PLACEHOLDER}" >&2
    exit 1
  fi

  if ! grep -Eq "AWS_SECRET_ACCESS_KEY:[[:space:]]*<SECRET_ACCESS_KEY_PLACEHOLDER>" "${TEMPLATE_FILE}"; then
    echo "Error: Missing placeholder in template: ${SECRET_KEY_PLACEHOLDER}" >&2
    exit 1
  fi

  local escaped_access_key_id
  local escaped_secret_access_key
  escaped_access_key_id="$(escape_sed_replacement "${ACCESS_KEY_ID}")"
  escaped_secret_access_key="$(escape_sed_replacement "${SECRET_ACCESS_KEY}")"

  local tmp_template_file
  tmp_template_file="$(mktemp "${TEMPLATE_FILE}.XXXXXX")"

  sed \
    -e "s|${ACCESS_KEY_PLACEHOLDER}|AWS_ACCESS_KEY_ID: ${escaped_access_key_id}|g" \
    -e "s|${SECRET_KEY_PLACEHOLDER}|AWS_SECRET_ACCESS_KEY: ${escaped_secret_access_key}|g" \
    "${TEMPLATE_FILE}" > "${tmp_template_file}"

  mv "${tmp_template_file}" "${TEMPLATE_FILE}"
}

main() {
  if [[ -f "${ACCESS_KEYS_FILE}" ]]; then
    echo "Found existing access keys file: ${ACCESS_KEYS_FILE}"
    echo "Skipping access key creation and reusing existing values."
  else
    run_access_key_command
  fi

  parse_access_keys
  replace_template_values
  echo "Updated placeholders in: ${TEMPLATE_FILE}"
}

main "$@"
