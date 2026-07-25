#!/bin/bash

# Get HTTP status code of guvi.in
status_code=$(curl -o /dev/null -s -w "%{http_code}\n" https://guvi.in)

# Print the status code
echo "HTTP Status Code: $status_code"

# Check response code
if [ "$status_code" -eq 200 ]; then
    echo "Success: Website is reachable"
else
    echo "Failure: Website returned an error"
fi
