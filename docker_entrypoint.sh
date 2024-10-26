#!/bin/sh

echo
echo "Starting MySpeed..."
echo

# Set the working directory
WORKDIR="/myspeed"

# Navigate to the application directory
cd "$WORKDIR" || { echo "Failed to enter directory: $WORKDIR"; exit 1; }

# Log the contents of the working directory for debugging
echo "Contents of $WORKDIR directory:"
ls -l "$WORKDIR"

# Check if the server directory exists and start the Node.js server
if [ -d "server" ]; then
    echo "Starting the Node.js server in the 'server' directory..."
    exec node server
else
    echo "Error: server directory does not exist."
    exit 1
fi
