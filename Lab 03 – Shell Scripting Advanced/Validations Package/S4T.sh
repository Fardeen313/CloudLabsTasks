#!/bin/bash

SCRIPT="$HOME/scripts/check_server.sh"

# Check script exists
if [ ! -f "$SCRIPT" ]; then
    echo "Validation Failed: check_server.sh was not found."
    exit 1
fi

# Verify curl is used
if ! grep -q "curl" "$SCRIPT"; then
    echo "Validation Failed: Script does not use curl."
    exit 1
fi

# Execute script
OUTPUT=$(bash "$SCRIPT" 2>/dev/null)

# Verify expected output
if echo "$OUTPUT" | grep -qi "Server is available"; then
    echo "Validation Passed: Server availability check completed successfully."
    exit 0
else
    echo "Validation Failed: Script did not report server availability."
    exit 1
fi
