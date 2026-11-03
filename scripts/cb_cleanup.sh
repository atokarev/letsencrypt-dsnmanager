#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$SCRIPT_DIR/config"
source "$SCRIPT_DIR/utils.sh"

CERT_DOMAIN="${CERTBOT_IDENTIFIER:-$CERTBOT_DOMAIN}"
echo "Start challenge cleanup for \"$CERT_DOMAIN\""

TXT_ACME_NAME=$(get_txt_acme_name "$DOMAIN_NAME" "$CERT_DOMAIN") || exit 1

echo "Delete TXT for acme-challenge $TXT_ACME_NAME"
delete_txt_records_with_prefix $DOMAIN_NAME "$TXT_ACME_NAME"

echo "Done!"
