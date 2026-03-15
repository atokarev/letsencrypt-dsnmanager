#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$SCRIPT_DIR/config"
source "$SCRIPT_DIR/utils.sh"

echo "Start challenge \"$CERTBOT_DOMAIN\""

domain=$(echo "$CERTBOT_DOMAIN" | awk -F. '{print $(NF-1)"."$NF}')
echo "Domain name from certbot challenge: $domain"
if [[ "$domain" != "$DOMAIN_NAME" ]]; then
    echo "Warning: incorrect domain name configuration"
    exit 1
fi

TXT_ACME_NAME="_acme-challenge"

echo "Delete TXT for acme-challenge"
delete_txt_records_with_prefix $domain $TXT_ACME_NAME

echo "Set TXT acme challenge value \"$CERTBOT_VALIDATION\""
add_txt_record $domain $TXT_ACME_NAME "$CERTBOT_VALIDATION" 3600

echo "Wait 90 sec"
sleep 90

echo "Done!"
