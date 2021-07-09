# step 1: update flow properties
$input_path_1 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-international-repo\flows\plh-international-flavourshort.json"
$output_path_1 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-international-repo\temp\plh-international-flavour_expire.json"
node .\idems-chatbot-repo\scripts\update_expiration_time.js $input_path_1 60 $output_path_1
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

#step 4T: add translation and add quick replies to message text
$lang = "msa"

$input_path_T = $output_path_2 #$output_path_3
$translation_file_path = "C:\Users\fagio\Documents\translate-RapidPro\flavour\Malaysia\inventory\msa_translation_OFFICIAL.json"
$output_path_T = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-malaysia-repo\temp\plh-international-flavour_ABtesting_localised_malay.json"
$transl_inventory_path = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-malaysia-repo\temp\missing_bits_to_translate.json"
node C:\Users\fagio\Documents\translate-RapidPro\scripts\insert\create_localisation_from_translated_json_files.js $input_path_T $translation_file_path $lang $output_path_T $transl_inventory_path
Write-Output "created localization"

$input_path_4 = $output_path_T #$output_path_3
$output_path_4 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-malaysia-repo\temp\plh-international-flavour_ABtesting_localised_no_QR.json"
$debug_qr_path = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-malaysia-repo\temp\debug_QR_transl.txt"
node ..\translate-RapidPro\scripts\insert\add_quick_replies_to_msg_text_and_localization.js $input_path_4 $output_path_4 $debug_qr_path
Write-Output "removed quick replies"

# step 5 add safeguarding and translation
$input_path_5 = $output_path_4 #$output_path_3
$output_path_5 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-malaysia-repo\temp\plh-international-flavour_ABtesting_localised_no_QR_safeguarding.json"
$safeguarding_path = "C:\Users\fagio\Documents\safeguarding-rapidpro\input\safeguarding_malaysia.json"
node ..\safeguarding-rapidpro\add_safeguarding_to_flows.js $input_path_5 $safeguarding_path $output_path_5 $lang
Write-Output "added safeguarding"





