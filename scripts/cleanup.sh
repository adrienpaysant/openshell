#!/usr/bin/env bash
set -euo pipefail
name=${1:-openshell-poc-agent}
openshell sandbox delete "$name"
