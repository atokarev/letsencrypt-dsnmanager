#!/bin/bash

cd "$(dirname "$0")"
source ./scripts/config

certbot certonly \
	--manual \
	--preferred-challenges dns-01 \
	--agree-tos \
	--email $EMAIL \
	--manual-auth-hook ./scripts/cb_start.sh \
	--manual-cleanup-hook ./scripts/cb_cleanup.sh \
	-d $REQ_CERT_DOMAIN_NAME -d *.$REQ_CERT_DOMAIN_NAME \
	--server https://acme-v02.api.letsencrypt.org/directory \
	--non-interactive \
	--config-dir ./data/config \
	--work-dir ./data/work \
	--logs-dir ./data/logs
