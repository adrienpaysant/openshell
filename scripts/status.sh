#!/usr/bin/env bash
set -euo pipefail
openshell status
podman machine list
podman ps --all --format 'table {{.Names}}\t{{.Status}}\t{{.Image}}'
