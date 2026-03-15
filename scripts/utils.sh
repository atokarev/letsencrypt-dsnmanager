#!/bin/bash
set -e 

############################################################

AUTH_ID=$API_USERNAME:$API_PASSWORD

############################################################

get_domain_records() {
	local domain=$1
	local resp=$(curl -s -G -X GET "https://$API_HOST/dnsmgr" \
		--data "func=domain.record" \
		--data "out=json" \
		--data "sok=ok" \
		--data "authinfo=$AUTH_ID" \
		--data "elid=$domain")
	echo "$resp"
}

get_all_records() {
	local domain=$1
	local resp=$(get_domain_records "$domain")
	local out=$(jq -r '.doc.elem[] | .rkey["$"]' <<< "$resp")
	echo "$out"
}

get_all_a_records() {
	local domain=$1
	local resp=$(get_domain_records "$domain")
	local out=$(jq -r '.doc.elem[] | select(.rtype["$orig"]=="a") | .rkey["$"]' <<< "$resp")
	echo "$out"
}

get_all_aaaa_records() {
	local domain=$1
	local resp=$(get_domain_records $domain)
	local out=$(jq -r '.doc.elem[] | select(.rtype["$orig"]=="aaaa") | .rkey["$"]' <<< "$resp")
	echo "$out"
}

get_all_txt_records() {
	local domain=$1
	local resp=$(get_domain_records "$domain")
	local out=$(jq -r '.doc.elem[] | select(.rtype["$orig"]=="txt") | .rkey["$"]' <<< "$resp")
	echo "$out"
}

############################################################

get_all_txt_ids_start_with() {
	local domain=$1
	local prefix=$2
	if [ -z "$prefix" ]; then
        echo "Prefix is empty"
        return 1
    fi
    local resp=$(get_domain_records "$domain")
    local out=$(jq -r --arg prefix "$prefix" '.doc.elem[] | select(.rtype["$orig"]=="txt") | select(.name["$"] | startswith($prefix)) | .rkey["$"]' <<< "$resp")
	echo "$out"
}

############################################################

add_txt_record() {
	local domain=$1
	local txt_name=$2
	local txt_value=$3
	local txt_ttl=$4

	echo "Set TXT \"$txt_name\" value \"$txt_value\" ttl $txt_ttl"
	local http_code
	http_code=$(curl -sG -o /dev/null -w "%{http_code}"  -X GET "https://$API_HOST/dnsmgr" \
		--data "func=domain.record.edit" \
		--data "out=json" \
		--data "sok=ok" \
		--data "rtype=txt" \
		--data "authinfo=$AUTH_ID" \
		--data "plid=$domain" \
		--data "name=$txt_name" \
		--data "value=$txt_value" \
		--data "ttl=$txt_ttl")
	if [[ "$http_code" -ne 200 ]]; then
        echo "Error: http code $http_code"
        exit 1
    fi
}

############################################################

delete_record_by_id() {
	local domain=$1
	local record_id=$2
	local http_code
	http_code=$(curl -sG -o /dev/null -w "%{http_code}" "https://$API_HOST/dnsmgr" \
	    --data "func=domain.record.delete" \
	    --data "out=json" \
	    --data "authinfo=$AUTH_ID" \
	    --data "sok=ok" \
	    --data "plid=$domain" \
	    --data-urlencode "elid=$record_id")
	if [[ "$http_code" -ne 200 ]]; then
        echo "Error: http code $http_code"
        exit 1
    fi
}

delete_txt_records_with_prefix() {
	local domain=$1
	local prefix=$2
	txt_records=$(get_all_txt_ids_start_with "$domain" "$prefix")
	while IFS= read -r id; do
	    echo "Delete record: $id"
	    $(delete_record_by_id $domain "$id")
	done <<< "$txt_records"
}

############################################################
