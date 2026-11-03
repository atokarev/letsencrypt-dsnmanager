#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$SCRIPT_DIR/config"
source "$SCRIPT_DIR/utils.sh"

CERT_DOMAIN="${CERTBOT_IDENTIFIER:-$CERTBOT_DOMAIN}"

echo "Start challenge for \"$CERT_DOMAIN\""

TXT_ACME_NAME=$(get_txt_acme_name "$DOMAIN_NAME" "$CERT_DOMAIN") || exit 1

echo "TXT record name: ${TXT_ACME_NAME}.${DOMAIN_NAME}."
echo "ACME challenge value \"$CERTBOT_VALIDATION\""

echo "Delete TXT for acme-challenge"
delete_txt_records_with_prefix "$DOMAIN_NAME" "$TXT_ACME_NAME"

echo "Set TXT acme challenge value \"$CERTBOT_VALIDATION\""
add_txt_record "$DOMAIN_NAME" "$TXT_ACME_NAME" "$CERTBOT_VALIDATION" 3600

echo "Wait 90 sec"
sleep 90

echo "Done!"
