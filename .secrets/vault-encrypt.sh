#!/bin/bash
# Encrypt vault.json -> vault.enc (AES-256-CBC)
# Usage: ./vault-encrypt.sh
DIR="$(cd "$(dirname "$0")" && pwd)"
if [ ! -f "$DIR/vault.json" ]; then
    echo "No vault.json found to encrypt"
    exit 1
fi
openssl enc -aes-256-cbc -salt -pbkdf2 -in "$DIR/vault.json" -out "$DIR/vault.enc"
if [ $? -eq 0 ]; then
    rm "$DIR/vault.json"
    echo "Encrypted -> vault.enc (vault.json removed)"
else
    echo "Encryption failed"
    exit 1
fi
