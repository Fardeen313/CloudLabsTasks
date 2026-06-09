#!/bin/bash

if [ -f /opt/data/testfile.txt ]; then
    echo "File exists."
    exit 0
else
    echo "File not found."
    exit 1
fi
