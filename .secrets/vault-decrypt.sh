#!/bin/bash
# Decrypt vault.enc -> vault.json
# Usage: ./vault-decrypt.sh
DIR="$(cd "$(dirname "$0")" && pwd)"
if [ ! -f "$DIR/vault.enc" ]; then
    echo "No vault.enc found to decrypt"
    exit 1
fi
openssl enc -aes-256-cbc -d -pbkdf2 -in "$DIR/vault.enc" -out "$DIR/vault.json"
if [ $? -eq 0 ]; then
    echo "Decrypted -> vault.json"
else
    echo "Decryption failed (wrong passphrase?)"
    rm -f "$DIR/vault.json"
    exit 1
fi
