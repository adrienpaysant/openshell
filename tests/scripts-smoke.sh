#!/usr/bin/env bash
set -euo pipefail

root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

for required_path in \
  "$root_dir/Containerfile" \
  "$root_dir/scripts/audit.sh" \
  "$root_dir/scripts/build-agent-image.sh" \
  "$root_dir/scripts/configure-gateway.sh" \
  "$root_dir/scripts/create-sandbox.sh" \
  "$root_dir/scripts/cleanup.sh" \
  "$root_dir/configuration/gateway.toml.example" \
  "$root_dir/configuration/policies/README.md" \
  "$root_dir/README.md" \
  "$root_dir/architecture.md" \
  "$root_dir/installation.md" \
  "$root_dir/tests/filesystem.md" \
  "$root_dir/tests/README.md" \
  "$root_dir/tests/network.md" \
  "$root_dir/tests/process.md" \
  "$root_dir/tests/providers.md" \
  "$root_dir/tests/isolation.md"; do
  if ! test -f "$required_path"; then
    printf 'missing required file: %s\n' "$required_path" >&2
    exit 1
  fi
done

for script_path in "$root_dir"/scripts/*.sh; do
  bash -n "$script_path"
done
