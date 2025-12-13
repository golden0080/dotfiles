set -eux

# Set MOK_DIR to default if not already defined
MOK_DIR="${MOK_DIR:-/var/lib/shim-signed/mok}"
MOK_PKEY="${MOK_PKEY:-MOK.der}"

MOK_FILE="$MOK_DIR/$MOK_PKEY"

echo "Using MOK file: $MOK_FILE"

# Optional: check if file exists
if [[ ! -f "$MOK_FILE" ]]; then
    echo "Error: MOK file not found at $MOK_FILE"
    exit 1
fi

# Run mokutil import
sudo mokutil --import "$MOK_FILE"
