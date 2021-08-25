# step 1: update flow properties
$source_file_name = "GG-plh-international-flavour"
$input_path_1 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-international-repo\flows\" + $source_file_name + ".json"
$source_file_name = $source_file_name + "_expire"
$output_path_1 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-international-repo\temp\" + $source_file_name + ".json"
node .\idems-chatbot-repo\scripts\update_expiration_time.js $input_path_1 60 $output_path_1
Write-Output "updated expiration"

# step 2: flow edits & A/B testing
$SPREADSHEET_ID = '1KPakZyyuyHoRO5GCdyde-vOvKq2155pTl-VZKKIKcXI'
$JSON_FILENAME = $output_path_1
$source_file_name = $source_file_name + "_ABtesting"
$CONFIG_ab = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-malaysia-repo\edits\ab_config.json"
$output_path_2 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-international-repo\temp\" + $source_file_name + ".json"
Set-Location "C:\Users\fagio\Documents\rapidpro_abtesting"
#python .\main_from_bash.py $SPREADSHEET_ID $JSON_FILENAME $output_path_2
python .\main.py $JSON_FILENAME $output_path_2 $SPREADSHEET_ID --format google_sheets --logfile main_AB.log --config=$CONFIG_ab
Write-Output "added A/B tests"

## step 3: localisation
$SPREADSHEET_ID = '1rdEI_HWP7B_Q-J5ib9UYzDbbE4IWPbzA3-DfnGdZ0AM'
$JSON_FILENAME = $output_path_2
$source_file_name = $source_file_name + "_localised"
$output_path_3 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-malaysia-repo\temp\" + $source_file_name + ".json"
python main.py $JSON_FILENAME $output_path_3 $SPREADSHEET_ID --format google_sheets --logfile main_loc.log
#python .\main_from_bash.py $SPREADSHEET_ID $JSON_FILENAME $output_path_3
Write-Output "localised flows"

<#
# replace set language flow
$lang_chooser = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-malaysia-repo\edits\language_chooser_malaysia.csv"
python main_language_chooser.py $output_path_3 "PLH - Welcome - Entry - Set language" $output_path_3 $lang_chooser --format csv
Write-Output "replaced set language flow"
#>
Set-Location "C:\Users\fagio\Documents\parenttext-deployment"

#step 4T: add translation and add quick replies to message text
$lang = "msa"

$input_path_T = $output_path_3
$translation_file_path = "C:\Users\fagio\Documents\parentText-Malaysia-translation\OFFICIAL_Malaysia_msa_translation.json"
$source_file_name = $source_file_name + "_" + $lang
$output_name_T = $source_file_name +".json"
$transl_output_folder = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-malaysia-repo\temp"
node C:\Users\fagio\Documents\idems_translation\chatbot\index.js localize $input_path_T $translation_file_path $lang $output_name_T $transl_output_folder
Write-Output "created localization"

<#
$input_path_4 = $output_path_T
$source_file_name = $source_file_name + "_no_QR"
$output_path_4 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-malaysia-repo\temp\" + $source_file_name + ".json"
$debug_qr_path = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-malaysia-repo\temp\debug_QR_transl.txt"
node ..\translate-RapidPro\scripts\insert\add_quick_replies_to_msg_text_and_localization.js $input_path_4 $output_path_4 $debug_qr_path
Write-Output "removed quick replies"

# step 5 add safeguarding and translation
$input_path_5 = $output_path_4
$source_file_name = $source_file_name + "_safeguarding"
$output_path_5 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-malaysia-repo\temp\"+ $source_file_name +".json"
$safeguarding_path = "C:\Users\fagio\Documents\safeguarding-rapidpro\input\safeguarding_malaysia.json"
node ..\safeguarding-rapidpro\add_safeguarding_to_flows.js $input_path_5 $safeguarding_path $output_path_5 $lang
Write-Output "added safeguarding"


# step final: split in 2 json files because it's too heavy to load (need to replace wrong flow names)
$input_path_6 = $output_path_5
node .\idems-chatbot-repo\scripts\split_in_multiple_json_files.js $input_path_6


#>
