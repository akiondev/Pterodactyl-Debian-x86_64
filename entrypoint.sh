#!/bin/bash
set -euo pipefail

cd /home/container

# Expand {{VAR}} placeholders in $STARTUP to $VAR
MODIFIED_STARTUP=$(eval echo "$(echo "${STARTUP:-}" | sed -e 's/{{/${/g' -e 's/}}/}/g')")

# Show the command that will run
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Execute the command
exec ${MODIFIED_STARTUP}
