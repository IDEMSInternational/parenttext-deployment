# step 1: update flow properties
$source_file_name = "GG-plh-international-flavour"
$deployment = "malaysia"

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
python .\main.py $JSON_FILENAME $output_path_2 $SPREADSHEET_ID --format google_sheets --logfile main_AB.log --config=$CONFIG_ab
Write-Output "added A/B tests"

## step 3: localisation
$SPREADSHEET_ID = '1rdEI_HWP7B_Q-J5ib9UYzDbbE4IWPbzA3-DfnGdZ0AM'
$JSON_FILENAME = $output_path_2
$source_file_name = $source_file_name + "_localised"
$output_path_3 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-malaysia-repo\temp\" + $source_file_name + ".json"
python main.py $JSON_FILENAME $output_path_3 $SPREADSHEET_ID --format google_sheets --logfile main_loc.log
Write-Output "localised flows"


<#
# replace set language flow
$lang_chooser = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-malaysia-repo\edits\language_chooser_malaysia.csv"
python main_language_chooser.py $output_path_3 "PLH - Welcome - Entry - Set language" $output_path_3 $lang_chooser --format csv
Write-Output "replaced set language flow"
#>
Set-Location "C:\Users\fagio\Documents\parenttext-deployment"


#step T: get PO files from translation repo and merge them into a single json

$lang = "msa"
$2lang = "ms"
$transl_repo = "C:\Users\fagio\Documents\GitHub\PLH-Digital-Content\translations\parent_text\" + $2lang+ "\"
$intern_transl = $transl_repo +  $2lang + "_messages.po"
$local_transl = $transl_repo +  $2lang+ "_" + $deployment + "_additional_messages.po"


$json_intern_transl = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-"+ $deployment +"-repo\temp\temp_transl\"+ $lang+ "\"  +$2lang + "_messages.json"
node C:\Users\fagio\Documents\idems_translation\common_tools\index.js convert $intern_transl $json_intern_transl

$json_local_transl = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-"+ $deployment +"-repo\temp\temp_transl\"+ $lang+ "\" +$2lang+ "_" + $deployment +"_additional_messages.json"
node C:\Users\fagio\Documents\idems_translation\common_tools\index.js convert $local_transl $json_local_transl

$json_translation_file_path = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-"+ $deployment +"-repo\temp\temp_transl\"+ $lang+ "\" + $2lang+ "_all_messages.json"
node C:\Users\fagio\Documents\idems_translation\common_tools\concatenate_json_files.js $json_local_transl $json_intern_transl $json_translation_file_path 


#step 4T: add translation 

$input_path_T = $output_path_3
$source_file_name = $source_file_name + "_" + $lang
$output_name_T = $source_file_name
$transl_output_folder = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-"+ $deployment +"-repo\temp\"
node C:\Users\fagio\Documents\idems_translation\chatbot\index.js localize $input_path_T $json_translation_file_path $lang $output_name_T $transl_output_folder
Write-Output "created localization"

# step 4QA: integrity check

$InputFile = $transl_output_folder + "\" + $output_name_T +".json"
$OutputDir = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-"+ $deployment +"-repo\temp\temp_transl"
$JSON9 = "9_has_any_words_check"
$JSON9Path = $OutputDir + '\' + $JSON9 + '.json'
$LOG10 = "10 - Log of changes after has_any_words_check"
$JSON11 = "11_fix_arg_qr_translation"
$JSON11Path = $OutputDir + '\' + $JSON11 + '.json'
$LOG12 = "12 - Log of changes after fix_arg_qr_translation"
$LOG13 = "13 - Log of erros in file found using overall_integrity_check"
    
Node C:\Users\fagio\Documents\GitHub\idems_translation\chatbot\index.js has_any_words_check $InputFile $OutputDir $JSON9 $LOG10
Node C:\Users\fagio\Documents\GitHub\idems_translation\chatbot\index.js fix_arg_qr_translation $JSON9Path $OutputDir $JSON11 $LOG12
Node C:\Users\fagio\Documents\GitHub\idems_translation\chatbot\index.js overall_integrity_check $JSON11Path $OutputDir $LOG13

Write-Output "Completed integrity check"


#step 5: remove quick replies 
$input_path_4 = $JSON11Path  #$transl_output_folder + "\" + $output_name_T +".json"
$source_file_name = $source_file_name + "_no_QR"
$select_phrases_file = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-malaysia-repo\edits\select_phrases.json"
$output_path_4 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-malaysia-repo\temp\"
$output_name_4 = $source_file_name
node C:\Users\fagio\Documents\idems_translation\chatbot\index.js move_quick_replies $input_path_4 $select_phrases_file $output_name_4 $output_path_4
Write-Output "removed quick replies"


# step 6 add safeguarding and translation
$input_path_5 = $output_path_4 + "\" + $output_name_4 +".json"
$source_file_name = $source_file_name + "_safeguarding"
$output_path_5 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-malaysia-repo\temp\"+ $source_file_name +".json"
$safeguarding_path = "C:\Users\fagio\Documents\safeguarding-rapidpro\input\safeguarding_malaysia.json"
node ..\safeguarding-rapidpro\add_safeguarding_to_flows.js $input_path_5 $safeguarding_path $output_path_5 $lang
Write-Output "added safeguarding"


# step final: split in 2 json files because it's too heavy to load (need to replace wrong flow names)
$input_path_6 = $output_path_5
node .\idems-chatbot-repo\scripts\split_in_multiple_json_files.js $input_path_6


