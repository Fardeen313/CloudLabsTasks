#!/bin/bash

grep "\[error\]" /opt/logs/application.log

TOTAL_ERRORS=$(grep -c "\[error\]" /opt/logs/application.log)

echo ""
echo "Total Errors: $TOTAL_ERRORS"