#!/bin/bash
set -e

echo "Packaging lambda_function.py -> lambda_function.zip..."

rm -f lambda_function.zip

zip lambda_function.zip lambda_function.py

echo "Created lambda_function.zip"