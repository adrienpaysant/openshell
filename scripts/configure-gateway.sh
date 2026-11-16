#!/usr/bin/env bash
set -euo pipefail
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
config_file=${GATEWAY_CONFIG:-"${XDG_CONFIG_HOME:-$HOME/.config}/openshell/gateway.toml"}
config_dir=$(dirname "$config_file")
mkdir -p "$config_dir"
if test -e "$config_file"; then
  printf 'Refusing to overwrite existing configuration: %s\n' "$config_file" >&2
  exit 1
fi
cp "$script_dir/../configuration/gateway.toml.example" "$config_file"
openshell-gateway config preflight --path "$config_file"
brew services restart openshell
printf 'Configured %s\n' "$config_file"
