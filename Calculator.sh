#!/bin/bash

# Display the calculator menu
echo "Simple Calculator"
echo "1. Addition"
echo "2. Subtraction"
echo "3. Multiplication"
echo "4. Division"
echo "Enter your choice (1-4): "
read choice

# Evaluate the user's choice using a case statement
case $choice in
1)
    echo "Addition"
    echo "Enter the first number: "
    read num1
    echo "Enter the second number: "
    read num2
    result=$((num1 + num2))
    echo "Result: $result"
    ;;
2)
    echo "Subtraction"
    echo "Enter the first number: "
    read num1
    echo "Enter the second number: "
    read num2
    result=$((num1 - num2))
    echo "Result: $result"
    ;;
3)
    echo "Multiplication"
    echo "Enter the first number: "
    read num1
    echo "Enter the second number: "
    read num2
    result=$((num1 * num2))
    echo "Result: $result"
    ;;
4)
    echo "Division"
    echo "Enter the dividend: "
    read num1
    echo "Enter the divisor: "
    read num2
    if [ $num2 -eq 0 ]; then
        echo "Error: Division by zero is not allowed"
    else
        result=$((num1 / num2))
        echo "Result: $result"
    fi
    ;;
*)
    echo "Invalid choice"
    ;;
esac
