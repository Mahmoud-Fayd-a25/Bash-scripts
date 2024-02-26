#!/bin/bash

read -p "Enter the first number: " num1
read -p "Choose the operator (+, -, *, /): " operator
read -p "Enter the second number: " num2


if [ "$operator" = "+" ]; then
  result=$((num1 + num2))
elif [ "$operator" = "-" ]; then
  result=$((num1 - num2))
elif [ "$operator" = "*" ]; then
  result=$((num1 * num2))
elif [ "$operator" = "/" ]; then
  result=$((num1 / num2))
else
  echo "Invalid operator"
fi

echo "Result: $result"
