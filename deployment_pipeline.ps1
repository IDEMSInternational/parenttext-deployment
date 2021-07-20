# step 1: update flow properties
$input_path_1 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-international-repo\flows\plh-international-flavour.json"
$output_path_1 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-international-repo\temp\plh-international-flavour_expire.json"
node .\RapidPro-Flows\scripts\update_expiration_time.js $input_path_1 60 $output_path_1
Write-Output "updated expiration"

# step 2: flow edits & A/B testing
$SPREADSHEET_ID = '1KPakZyyuyHoRO5GCdyde-vOvKq2155pTl-VZKKIKcXI'
$JSON_FILENAME = $output_path_1
$output_path_2 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-international-repo\temp\plh-international-flavour_ABtesting.json"
Set-Location "C:\Users\fagio\Documents\rapidpro_abtesting"
python .\main_from_bash.py $SPREADSHEET_ID $JSON_FILENAME $output_path_2
Write-Output "added A/B tests"

## step 3: localisation
#$SPREADSHEET_ID = ''
#$JSON_FILENAME = $output_path_2
#$output_path_3 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-malaysia-repo\temp\plh-international-flavour_ABtesting_localised.json"
#python .\main_from_bash.py $SPREADSHEET_ID $JSON_FILENAME $output_path_3
#Write-Output "localised flows"
Set-Location "C:\Users\fagio\Documents\parenttext-deployment"


# step 4: add quick replies to message text
$input_path_4 = $output_path_2 #$output_path_3
$output_path_4 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-malaysia-repo\temp\plh-international-flavour_ABtesting_localised_no_QR.json"
$debug_qr_path = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-malaysia-repo\temp\debug_QR.txt"
node .\RapidPro-Flows\scripts\add_quick_replies_to_msg_text.js $input_path_4 $output_path_4 $debug_qr_path
Write-Output "removed quick replies"

$input_path_5 = $output_path_4 #$output_path_3
$output_path_5 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-malaysia-repo\temp\plh-international-flavour_ABtesting_localised_no_QR_safeguarding.json"
$safeguarding_path = "C:\Users\fagio\Documents\safeguarding-rapidpro\input\safeguarding_malaysia.json"
node .\safeguarding-rapidpro\add_safeguarding_to_flows.js $input_path_5 $safeguarding_path $output_path_5 "eng"
Write-Output "added safeguarding"

# step final: split in 2 json files because it's too heavy to load (need to replace wrong flow names)
$input_path_6 = $output_path_5
node .\RapidPro-Flows\scripts\split_in_multiple_json_files.js $input_path_6
