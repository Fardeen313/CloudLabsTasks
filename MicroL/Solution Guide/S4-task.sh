#!/bin/bash

if curl -s http://localhost > /dev/null; then
    echo "Server is available"
else
    echo "Server is unavailable"
fi
