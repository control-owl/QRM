#!/usr/bin/env bash
# version 0.1

long_hex=$(curl -s "https://qrng.anu.edu.au/API/jsonI.php?length=10&type=hex16&size=1024")
error_text="The QRNG API is limited to 1 requests per minute."


if [[ "$long_hex" == *"$error_text"* ]]
then
    echo "$error_text"
    exit 1
else
    echo "Downloaded"
    echo "$long_hex" | jq -r '.data[]' | tr -d '\n' > hex16.txt
fi
