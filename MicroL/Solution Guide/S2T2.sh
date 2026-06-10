#!/bin/bash

STATUS=$(sudo systemctl is-active httpd)

if [ "$STATUS" != "active" ]; then
    sudo systemctl start httpd
    echo "HTTPD service started."
else
    echo "HTTPD service is already running."
fi
