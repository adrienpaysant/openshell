#!/usr/bin/env bash
set -euo pipefail
name=${1:-openshell-poc-agent}
image_ref=${IMAGE_REF:-localhost/openshell-poc-agent:dev}
openshell sandbox create --name "$name" --from "$image_ref" --cpu 500m --memory 384Mi -- /bin/bash
