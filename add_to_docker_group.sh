#!/bin/bash

# Get the current logged in user
USER=$(whoami)

# Check if the user is already in the docker group
if ! groups $USER | grep &>/dev/null "\bdocker\b"; then
    sudo usermod -aG docker $USER
    echo "$USER has been added to the docker group."
fi