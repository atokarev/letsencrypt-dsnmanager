 #!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$SCRIPT_DIR/config"
source "$SCRIPT_DIR/utils.sh"

# read all domain records
all_records=$(get_all_records $DOMAIN_NAME)
echo "~~~~~~~~~~~~~~~~~~~~~~~~~"
echo -e "Records:\n$all_records"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~"

# set TXT records
echo "~~~~~~~~~~~~~~~~~~~~~~~~~"
add_txt_record $DOMAIN_NAME "_acme-challenge1" "11111" 3600
add_txt_record $DOMAIN_NAME "_acme-challenge2" "22222" 3600
add_txt_record $DOMAIN_NAME "_acme-challenge3" "33333" 3600
echo "~~~~~~~~~~~~~~~~~~~~~~~~~"

# get all TXT records
echo "~~~~~~~~~~~~~~~~~~~~~~~~~"
txt_records=$(get_all_txt_records $DOMAIN_NAME)
echo -e "TXT:\n$txt_records"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~"

# get filtered TXT records
echo "~~~~~~~~~~~~~~~~~~~~~~~~~"
txt_records_acme=$(get_all_txt_ids_start_with $DOMAIN_NAME "_acme-challenge")
echo -e "TXT (acme-challenge):\n$txt_records_acme"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~"

# delete TXT records
echo "~~~~~~~~~~~~~~~~~~~~~~~~~"
while IFS= read -r id; do
    echo "Delete ACME TXT: $id"
    $(delete_record_by_id $DOMAIN_NAME "$id")
done <<< "$txt_records_acme"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~"

# get all TXT records
echo "~~~~~~~~~~~~~~~~~~~~~~~~~"
txt_records=$(get_all_txt_records $DOMAIN_NAME)
echo -e "TXT:\n$txt_records"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~"

# get all A records
echo "~~~~~~~~~~~~~~~~~~~~~~~~~"
a_records=$(get_all_a_records $DOMAIN_NAME)
echo -e "A:\n$a_records"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~"

# get all AAAA records
echo "~~~~~~~~~~~~~~~~~~~~~~~~~"
aaaa_records=$(get_all_aaaa_records $DOMAIN_NAME)
echo -e "AAAA:\n$aaaa_records"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~"

echo "Done!"