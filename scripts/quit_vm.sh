#!/bin/bash

# Input parameters.
if [[ $# != 1 ]]; then
  echo "Usage: $0 <SOCKET>"
  exit 1
fi

socket=$1

echo '{"execute": "qmp_capabilities"} {"execute": "quit"}' | nc -U "${socket}"
