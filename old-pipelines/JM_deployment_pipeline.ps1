# step 1: update flow properties
$source_file_name = "JM-plh-international-flavour"
$input_path_1 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-international-repo\flows\" + $source_file_name + ".json"
$source_file_name = $source_file_name + "_expire"
$output_path_1 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-international-repo\temp\" + $source_file_name + ".json"
node .\idems-chatbot-repo\scripts\update_expiration_time.js $input_path_1 60 $output_path_1
Write-Output "updated expiration"

# step 2: flow edits & A/B testing
$deployment = "jamaica"
$SPREADSHEET_ID_ab = '1KPakZyyuyHoRO5GCdyde-vOvKq2155pTl-VZKKIKcXI'
$SPREADSHEET_ID_loc = '1YSHxIPfFJhf-jLzgd8P7-Y2-eIO_dc9jV7dkKBL1oXw'
$JSON_FILENAME = $output_path_1
$source_file_name = $source_file_name + "_ABtesting"
$CONFIG_ab = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-" + $deployment + "-repo\edits\ab_config.json"
$output_path_2 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-" + $deployment + "-repo\temp\" + $source_file_name + ".json"
Set-Location "C:\Users\fagio\Documents\rapidpro_abtesting"
python .\main.py $JSON_FILENAME $output_path_2 $SPREADSHEET_ID_ab $SPREADSHEET_ID_loc --format google_sheets --logfile main_AB.log --config=$CONFIG_ab
Write-Output "added A/B tests and localisation"

$SPREADSHEET_ID_loc_sub = '1uFKo5bNkafHQ2ZTOK9x_qCLOv4Khq2aStkI457hsp34'
$JSON_FILENAME = $output_path_2
python .\main.py $JSON_FILENAME $output_path_2 $SPREADSHEET_ID_loc_sub --format google_sheets --logfile main_AB_sub.log --config=$CONFIG_ab
Write-Output "added subseq localisation"

Set-Location "C:\Users\fagio\Documents\parenttext-deployment"


$input_path_4 = $output_path_2
$source_file_name = $source_file_name + "_no_QR"
$select_phrases_file = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-" + $deployment + "-repo\edits\select_phrases.json"
$output_path_4 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-" + $deployment + "-repo\temp\"
$output_name_4 = $source_file_name 
node C:\Users\fagio\Documents\idems_translation\chatbot\index.js move_quick_replies $input_path_4 $select_phrases_file $output_name_4 $output_path_4
Write-Output "removed quick replies"


$input_path_5 = $output_path_4 + $output_name_4 +".json"
$source_file_name = $source_file_name + "_safeguarding"
$output_path_5 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-" + $deployment + "-repo\temp\"+ $source_file_name +".json"
$safeguarding_path = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-" + $deployment + "-repo\edits\" + $deployment +"_safeguarding.json"

node C:\Users\fagio\Documents\GitHub\safeguarding-rapidpro\add_safeguarding_to_flows_mult_lang.js $input_path_5 $safeguarding_path $output_path_5
Write-Output "added safeguarding"

# step final: split in 2 json files because it's too heavy to load (need to replace wrong flow names)
$input_path_6 = $output_path_5
node .\idems-chatbot-repo\scripts\split_in_multiple_json_files.js $input_path_6

#>