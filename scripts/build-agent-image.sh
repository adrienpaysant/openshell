#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
root_dir=$(cd "$script_dir/.." && pwd)
image_ref=${IMAGE_REF:-localhost/openshell-poc-agent:dev}

podman build --platform linux/arm64 --tag "$image_ref" --file "$root_dir/Containerfile" "$root_dir"
printf 'Built %s\n' "$image_ref"
