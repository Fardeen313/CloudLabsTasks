#!/bin/bash

SCRIPT="/home/Labuser/scripts/parse_logs.sh"

[ -f "$SCRIPT" ] || { echo FAIL; exit 1; }

[ -x "$SCRIPT" ] || { echo FAIL; exit 1; }

grep -q "/opt/logs/application.log" "$SCRIPT" || {
    echo FAIL
    exit 1
}

OUTPUT=$($SCRIPT 2>/dev/null)

# Ensure at least one error line is displayed
ERROR_LINES=$(echo "$OUTPUT" | grep -i "error" | wc -l)

if [ "$ERROR_LINES" -lt 1 ]; then
    echo FAIL
    exit 1
fi

# Extract error count
TOTAL_ERRORS=$(echo "$OUTPUT" | grep -oE 'Total Errors:[[:space:]]*[0-9]+' | grep -oE '[0-9]+')

if [ -z "$TOTAL_ERRORS" ]; then
    echo FAIL
    exit 1
fi

if [ "$TOTAL_ERRORS" -lt 3 ]; then
    echo FAIL
    exit 1
fi

echo PASS
