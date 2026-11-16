#!/usr/bin/env bash
set -euo pipefail

printf 'macOS: '; sw_vers -productVersion
printf 'architecture: '; uname -m
podman --version
podman machine list
podman system connection list
podman info
