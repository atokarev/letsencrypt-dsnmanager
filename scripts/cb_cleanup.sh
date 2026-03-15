#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$SCRIPT_DIR/config"
source "$SCRIPT_DIR/utils.sh"

echo "Start challenge cleanup"

echo "Delete TXT for acme-challenge"
delete_txt_records_with_prefix $DOMAIN_NAME "_acme-challenge"

echo "Done!"