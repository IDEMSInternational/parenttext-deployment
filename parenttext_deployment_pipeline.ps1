# step 0: filter flows
$source_file_name = "plh-international-flavour"
$input_path_0 = ".\parenttext-international-repo\flows\plh-international-flavour.json"

if ($depl_prefix){
    $source_file_name = $depl_prefix  + "-" + $source_file_name 
}

$output_path_0 = ".\parenttext-" + $deployment + "-repo\temp\" + $source_file_name + ".json"
node .\idems-chatbot-repo\scripts\filter_flows.js $input_path_0 $output_path_0 $depl_prefix
Write-Output "filtered flows"

#remove triggers
if ($remove_triggers){
node .\idems-chatbot-repo\scripts\remove_triggers.js $output_path_0 $output_path_0
}

# step 1: update flow properties
$input_path_1 = ".\parenttext-" + $deployment + "-repo\temp\" + $source_file_name + ".json"
$source_file_name = $source_file_name + "_expire"
$output_path_1 = ".\parenttext-" + $deployment + "-repo\temp\" + $source_file_name + ".json"
$default_expiration_time = $default_expiration_time
$expiration_times =  ".\parenttext-international-repo\edits\expiration_times.json"
node .\idems-chatbot-repo\scripts\update_expiration_time.js $input_path_1 $expiration_times $default_expiration_time $output_path_1
Write-Output "updated expiration"



# step 2: flow edits & A/B testing
$deployment = $deployment
$SPREADSHEET_ID_ab = '1KPakZyyuyHoRO5GCdyde-vOvKq2155pTl-VZKKIKcXI'
$SPREADSHEET_ID_loc = $SPREADSHEET_ID_loc
$JSON_FILENAME = "..\parenttext-deployment\" + $output_path_1
$source_file_name = $source_file_name + "_ABtesting"
$CONFIG_ab = "..\parenttext-deployment\parenttext-" + $deployment + "-repo\edits\" + $CONFIG_ab_name +".json"
$output_path_2 = "parenttext-" + $deployment + "-repo\temp\" + $source_file_name + ".json"
$AB_log = "..\parenttext-deployment\parenttext-" + $deployment + "-repo\temp\AB_warnings.log"
Set-Location "..\rapidpro_abtesting"
python main.py $JSON_FILENAME ("..\parenttext-deployment\" +$output_path_2) $SPREADSHEET_ID_ab $SPREADSHEET_ID_loc --format google_sheets --logfile $AB_log --config=$CONFIG_ab
Write-Output "added A/B tests and localisation"

Set-Location "..\parenttext-deployment"

# fix issues with _ui
node .\idems-chatbot-repo\scripts\fix_ui.js $output_path_2 $output_path_2
Write-Output "fixed _ui"

#step 4T: add translation and add quick replies to message text

$languages =  $languages
$2languages = $2languages
$deployment_ = $deployment_
$transl_output_folder = ".\parenttext-" + $deployment + "-repo\temp"

$input_path_T = $output_path_2
for ($i=0; $i -lt $languages.length; $i++) {
	$lang = $languages[$i]
    $2lang = $2languages[$i]

    #step T: get PO files from translation repo and merge them into a single json
    $transl_repo = "..\PLH-Digital-Content\translations\parent_text\" + $2lang+ "\"
    $intern_transl = $transl_repo +  $2lang + "_messages.po"
    $local_transl = $transl_repo +  $2lang+ "_" + $deployment_ + "_additional_messages.po"

    $json_intern_transl = ".\parenttext-"+ $deployment +"-repo\temp\temp_transl\"+ $lang+ "\"  +$2lang + "_messages.json"
    node ..\idems_translation\common_tools\index.js convert $intern_transl $json_intern_transl

    $json_local_transl = ".\parenttext-"+ $deployment +"-repo\temp\temp_transl\"+ $lang+ "\" +$2lang+ "_" + $deployment +"_additional_messages.json"
    node ..\idems_translation\common_tools\index.js convert $local_transl $json_local_transl

    $json_translation_file_path = ".\parenttext-"+ $deployment +"-repo\temp\temp_transl\"+ $lang+ "\" + $2lang+ "_all_messages.json"
    node ..\idems_translation\common_tools\concatenate_json_files.js $json_local_transl $json_intern_transl $json_translation_file_path 


    $source_file_name = $source_file_name + "_" + $lang
    
    node ..\idems_translation\chatbot\index.js localize $input_path_T $json_translation_file_path $lang $source_file_name $transl_output_folder
   
    $input_path_T = $transl_output_folder + "\" + $source_file_name +".json"
    Write-Output ("created localization for " + $lang)
}

# step 4TE: translation edits
if ($SPREADSHEET_ID_transl){
    
    $JSON_FILENAME = "..\parenttext-deployment\parenttext-" + $deployment + "-repo\temp\" + $source_file_name +".json"
    $source_file_name = $source_file_name + "_edited"
    $output_path_t_edit = "..\parenttext-deployment\parenttext-" + $deployment + "-repo\temp\" + $source_file_name + ".json"
    $transl_log = "..\parenttext-deployment\parenttext-" + $deployment + "-repo\temp\transl_warnings.log"
    Set-Location "..\rapidpro_abtesting"
    python main.py $JSON_FILENAME $output_path_t_edit $SPREADSHEET_ID_transl --format google_sheets --logfile $transl_log
    Write-Output "Edited translations"
    Set-Location "..\parenttext-deployment"
}

# step 4QA: integrity check

$InputFile = $transl_output_folder + "\" +  $source_file_name +".json"
$OutputDir = ".\parenttext-"+ $deployment +"-repo\temp\temp_transl"
$JSON9 = "9_has_any_words_check"
$JSON9Path = $OutputDir + '\' + $JSON9 + '.json'
$LOG10 = "10 - Log of changes after has_any_words_check"
$JSON11 = "11_fix_arg_qr_translation"
$JSON11Path = $OutputDir + '\' + $JSON11 + '.json'
$LOG12 = "12 - Log of changes after fix_arg_qr_translation"
$LOG13 = "13 - Log of erros in file found using overall_integrity_check"
$LOG14 = $OutputDir + "\Excel Acceptance Log.xlsx"
    
Node ..\idems_translation\chatbot\index.js has_any_words_check $InputFile $OutputDir $JSON9 $LOG10
Node ..\idems_translation\chatbot\index.js fix_arg_qr_translation $JSON9Path $OutputDir $JSON11 $LOG12
Node ..\idems_translation\chatbot\index.js overall_integrity_check $JSON11Path $OutputDir $LOG13 $LOG14

Write-Output "Completed integrity check"



# step 4: add quick replies to message text and translation

$input_path_4 = $JSON11Path
$source_file_name = $source_file_name + "_no_QR"
$select_phrases_file = ".\parenttext-" + $deployment + "-repo\edits\select_phrases.json"
$output_path_4 = ".\parenttext-" + $deployment + "-repo\temp\"
$output_name_4 = $source_file_name 
node ..\idems_translation\chatbot\index.js move_quick_replies $input_path_4 $select_phrases_file $output_name_4 $output_path_4
Write-Output "removed quick replies"


$input_path_5 = $output_path_4 + $output_name_4 +".json"
$source_file_name = $source_file_name + "_safeguarding"
$output_path_5 = ".\parenttext-" + $deployment + "-repo\temp\"+ $source_file_name +".json"
$safeguarding_path = ".\parenttext-" + $deployment + "-repo\edits\" + $deployment_ + "_safeguarding.json"
node ..\safeguarding-rapidpro\add_safeguarding_to_flows_mult_lang.js $input_path_5 $safeguarding_path $output_path_5
Write-Output "added safeguarding"

# step final: split in 2 json files because it's too heavy to load (need to replace wrong flow names)
$input_path_6 = $output_path_5
$n_files = $n_files
node .\idems-chatbot-repo\scripts\split_in_multiple_json_files.js $input_path_6 $n_files


