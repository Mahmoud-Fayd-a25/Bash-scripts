#!/bin/bash

# Prompt the user for an email address
echo "Enter your email address:"
read email

# Check if the email address is valid
if [[ $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "Valid email address"
else
    echo "Invalid email address"
fi
