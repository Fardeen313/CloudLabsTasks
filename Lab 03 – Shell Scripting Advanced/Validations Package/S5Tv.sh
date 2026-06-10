#!/bin/bash

SCRIPT="$HOME/scripts/file_check.sh"

# Check if script exists
if [ ! -f "$SCRIPT" ]; then
    echo "Validation Failed: file_check.sh was not found."
    exit 1
fi

# Check for success exit code
if ! grep -q "exit 0" "$SCRIPT"; then
    echo "Validation Failed: Success exit code (exit 0) was not found."
    exit 1
fi

# Check for failure exit code
if ! grep -q "exit 1" "$SCRIPT"; then
    echo "Validation Failed: Failure exit code (exit 1) was not found."
    exit 1
fi

# Check if script references the required file
if ! grep -q "/opt/data/testfile.txt" "$SCRIPT"; then
    echo "Validation Failed: Script does not reference /opt/data/testfile.txt."
    exit 1
fi

# Execute script and verify success exit code
bash "$SCRIPT" >/dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Validation Failed: Script did not return exit code 0 when the file exists."
    exit 1
fi

echo "Validation Passed: Exit codes are implemented correctly."
exit 0