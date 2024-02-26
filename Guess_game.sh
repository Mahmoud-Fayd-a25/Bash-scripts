#!/bin/bash

# Generate a random number between 1 and 100
TARGET=$((RANDOM % 100 + 1))

# Initialize variables for input validation
guess=""
attempts=0
max_attempts=10

# Function to handle user input and validation
get_guess() {
    local input
    read -p "Guess the number (1-100): " input
    # Ensure input is an integer within the valid range
    if [[ $input =~ ^[0-9]+$ && $input -ge 1 && $input -le 100 ]]; then
        guess=$input
    else
        echo "Invalid input. Please enter a number between 1 and 100."
        get_guess
    fi
}

# Game loop
while [[ $guess -ne $TARGET && $attempts -lt $max_attempts ]]; do
    get_guess
    attempts=$((attempts + 1))

    if [[ $guess -gt $TARGET ]]; then
        echo "Too high!"
    elif [[ $guess -lt $TARGET ]]; then
        echo "Too low!"
    else
        echo "Congratulations! You guessed the number in $attempts attempts."
        break
    fi
done

if [[ $attempts -eq $max_attempts ]]; then
    echo "Sorry, you ran out of attempts. The number was $TARGET."
fi
