#!/usr/bin/env bash
set -euo pipefail
if command -v openshell >/dev/null 2>&1; then
  openshell --version
  exit 0
fi
curl -LsSf https://raw.githubusercontent.com/NVIDIA/OpenShell/main/install.sh | sh
