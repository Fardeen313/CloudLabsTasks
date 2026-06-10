#!/bin/bash

SCRIPT="$HOME/scripts/system_report.sh"
LOG_FILE="/tmp/system_report.log"

if [ ! -f "$SCRIPT" ]; then
    echo "Validation Failed: system_report.sh was not found."
    exit 1
fi

if [ ! -x "$SCRIPT" ]; then
    echo "Validation Failed: system_report.sh is not executable."
    exit 1
fi

# Execute script
bash "$SCRIPT" >/dev/null 2>&1

sleep 2

if [ ! -f "$LOG_FILE" ]; then
    echo "Validation Failed: /tmp/system_report.log was not created."
    exit 1
fi

if [ ! -s "$LOG_FILE" ]; then
    echo "Validation Failed: /tmp/system_report.log is empty."
    exit 1
fi

echo "Validation Passed: system_report.sh executed successfully and generated report output."
exit 0
