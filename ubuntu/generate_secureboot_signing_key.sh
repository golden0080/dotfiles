set -eux

TODAY=$(date +"%Y-%m-%d")
openssl req -new -x509 -newkey rsa:4096 -keyout MOK.priv \
        -outform DER -out MOK.der -nodes -days 3650 \
        -subj "/CN=Custom Secure Boot Signing Key $TODAY/"

SIGN_FILE=/usr/src/linux-headers-$(uname -r)/scripts/sign-file

sudo find /lib/modules/$(uname -r)/updates/dkms -name 'amd*.ko' -exec \
     $SIGN_FILE sha256 MOK.priv MOK.der {} \;

