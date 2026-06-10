#!/bin/bash

SCRIPT="$HOME/scripts/monitor_service.sh"

if [ ! -f "$SCRIPT" ]; then
    echo "Validation Failed: monitor_service.sh was not found."
    exit 1
fi

if ! grep -q "httpd" "$SCRIPT"; then
    echo "Validation Failed: Script does not reference the HTTPD service."
    exit 1
fi

bash "$SCRIPT" >/dev/null 2>&1

sleep 2

if [ "$(systemctl is-active httpd)" = "active" ]; then
    echo "Validation Passed: HTTPD service is running."
    exit 0
else
    echo "Validation Failed: HTTPD service is not running."
    exit 1
fi

# #!/bin/bash

# SCRIPT="$HOME/scripts/monitor_service.sh"

# # Check if script exists
# if [ ! -f "$SCRIPT" ]; then
#     echo "Validation Failed: monitor_service.sh was not found."
#     exit 1
# fi

# # Check if script references httpd
# if ! grep -q "httpd" "$SCRIPT"; then
#     echo "Validation Failed: Script does not reference the HTTPD service."
#     exit 1
# fi

# # Check for monitoring logic
# if ! grep -Eq "systemctl.*(is-active|status)" "$SCRIPT"; then
#     echo "Validation Failed: Monitoring logic was not detected."
#     exit 1
# fi

# # Check for restart/start logic
# if ! grep -q "systemctl start httpd" "$SCRIPT"; then
#     echo "Validation Failed: Script does not contain logic to start the HTTPD service."
#     exit 1
# fi

# # Stop service before functional test
# sudo systemctl stop httpd >/dev/null 2>&1

# # Execute user script
# bash "$SCRIPT" >/dev/null 2>&1

# sleep 3

# # Verify service is running
# if [ "$(systemctl is-active httpd)" = "active" ]; then
#     echo "Validation Passed: HTTPD service was successfully monitored and started by the script."
#     exit 0
# else
#     echo "Validation Failed: HTTPD service is not running after script execution."
#     exit 1
# fi
