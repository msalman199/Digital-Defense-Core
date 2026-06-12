#!/bin/bash

KEY_DIR="/opt/cloud-security-lab/keys"
ACTIVE_DIR="$KEY_DIR/active"
BACKUP_DIR="$KEY_DIR/backup"

# Function to generate a new encryption key
generate_key() {
    local key_name=$1
    local key_file="$ACTIVE_DIR/${key_name}.key"
    
    # Generate a 256-bit AES key
    openssl rand -hex 32 > "$key_file"
    chmod 600 "$key_file"
    
    echo "Generated encryption key: $key_file"
}

# Function to encrypt a file
encrypt_file() {
    local input_file=$1
    local key_name=$2
    local output_file="${input_file}.encrypted"
    local key_file="$ACTIVE_DIR/${key_name}.key"
    
    if [ ! -f "$key_file" ]; then
        echo "Error: Key $key_name not found"
        return 1
    fi
    
    # Encrypt the file using AES-256-CBC
    openssl enc -aes-256-cbc -salt -in "$input_file" -out "$output_file" -pass file:"$key_file"
    
    echo "File encrypted: $output_file"
}

# Function to decrypt a file
decrypt_file() {
    local input_file=$1
    local key_name=$2
    local output_file="${input_file%.encrypted}.decrypted"
    local key_file="$ACTIVE_DIR/${key_name}.key"
    
    if [ ! -f "$key_file" ]; then
        echo "Error: Key $key_name not found"
        return 1
    fi
    
    # Decrypt the file
    openssl enc -aes-256-cbc -d -in "$input_file" -out "$output_file" -pass file:"$key_file"
    
    echo "File decrypted: $output_file"
}

# Generate default keys
generate_key "data-encryption"
generate_key "backup-encryption"
generate_key "log-encryption"

echo "Key management system initialized"
