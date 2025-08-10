#!/bin/bash
set -euo pipefail

cd /home/container

# Expand {{VAR}} placeholders in $STARTUP to $VAR
MODIFIED_STARTUP=$(eval echo "$(echo "${STARTUP:-}" | sed -e 's/{{/${/g' -e 's/}}/}/g')")

# Show the command that will run
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Execute via a login shell so quotes/pipes/env-assigns work reliably
exec bash -lc "${MODIFIED_STARTUP}"
