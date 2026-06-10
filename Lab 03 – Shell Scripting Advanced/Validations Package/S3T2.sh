#!/bin/bash

SCRIPT="$HOME/scripts/system_report.sh"

if [ ! -f "$SCRIPT" ]; then
    echo "Validation Failed: system_report.sh was not found."
    exit 1
fi

CRON_ENTRIES=$(crontab -l 2>/dev/null)

if [ -z "$CRON_ENTRIES" ]; then
    echo "Validation Failed: No cron jobs found."
    exit 1
fi

if ! echo "$CRON_ENTRIES" | grep -q "system_report.sh"; then
    echo "Validation Failed: Cron job for system_report.sh was not found."
    exit 1
fi

if ! echo "$CRON_ENTRIES" | grep -qE '^\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*'; then
    echo "Validation Failed: Cron schedule is not configured for every 1 minute."
    exit 1
fi

echo "Validation Passed: Cron job is configured to execute system_report.sh every 1 minutes."
exit 0
