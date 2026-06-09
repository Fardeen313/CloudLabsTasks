#!/bin/bash

if systemctl is-active --quiet httpd
then
    echo "HTTPD service is running."
else
    echo "HTTPD service was stopped."
    echo "Restarting service..."
    sudo systemctl start httpd

    if systemctl is-active --quiet httpd
    then
        echo "HTTPD service restarted successfully."
    fi
fi
