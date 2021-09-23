# step 1: update flow properties
$source_file_name = "plh-international-flavour"
$input_path_1 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-international-repo\flows\" + $source_file_name + ".json"
$source_file_name = $source_file_name + "_expire"
$output_path_1 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-international-repo\temp\" + $source_file_name + ".json"
node .\idems-chatbot-repo\scripts\update_expiration_time.js $input_path_1 60 $output_path_1
Write-Output "updated expiration"

# step 2: flow edits & A/B testing
$deployment = "south-africa"
$SPREADSHEET_ID = '1KPakZyyuyHoRO5GCdyde-vOvKq2155pTl-VZKKIKcXI'
$JSON_FILENAME = $output_path_1
$source_file_name = $source_file_name + "_ABtesting"
$CONFIG_ab = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-" + $deployment + "-repo\edits\ab_config.json"
$output_path_2 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-international-repo\temp\" + $source_file_name + ".json"
Set-Location "C:\Users\fagio\Documents\rapidpro_abtesting"
#python .\main_from_bash.py $SPREADSHEET_ID $JSON_FILENAME $output_path_2
python .\main.py $JSON_FILENAME $output_path_2 $SPREADSHEET_ID --format google_sheets --logfile main_AB.log --config=$CONFIG_ab
Write-Output "added A/B tests"

## step 3: localisation
$SPREADSHEET_ID = '1BZ6zKNwglzz8e3qhx1YCOMYxiSSnbDvRb3YxF-vvf_4'
$JSON_FILENAME = $output_path_2
$source_file_name = $source_file_name + "_localised"
$output_path_3 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-" + $deployment + "-repo\temp\" + $source_file_name + ".json"
python main.py $JSON_FILENAME $output_path_3 $SPREADSHEET_ID --format google_sheets --logfile main_loc.log
Write-Output "localised flows"


Set-Location "C:\Users\fagio\Documents\parenttext-deployment"


#step 4T: add translation and add quick replies to message text

#$languages = @("afr","sot","tsn","xho","zul")

$languages = @("afr")

$input_path_T = $output_path_3
for ($i=0; $i -lt $languages.length; $i++) {
	$lang = $languages[$i]

    
    $translation_file_path = "C:\Users\fagio\Documents\parentText-Malaysia-translation\" + $lang + ".json"
    $source_file_name = $source_file_name + "_" + $lang
    $output_name_T = $source_file_name
    $transl_output_folder = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-" + $deployment + "-repo\temp"
    node C:\Users\fagio\Documents\idems_translation\chatbot\index.js localize $input_path_T $translation_file_path $lang $output_name_T $transl_output_folder
    <#
    if ( $i -ge 1 )
        {
            Remove-Item ($transl_output_folder + "\" + $input_path_T +".json")
        }
    #>
    $input_path_T = $transl_output_folder + "\" + $output_name_T +".json"
    Write-Output ("created localization for " + $lang)
}



# step 4: add quick replies to message text and translation

$input_path_4 = $transl_output_folder + "\" + $output_name_T +".json"
$source_file_name = $source_file_name + "_no_QR"
$select_phrases_file = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-" + $deployment + "-repo\edits\select_phrases.json"
$output_path_4 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-" + $deployment + "-repo\temp\"
$output_name_4 = $source_file_name +".json"
node C:\Users\fagio\Documents\idems_translation\chatbot\index.js move_quick_replies $input_path_4 $select_phrases_file $output_name_4 $output_path_4
Write-Output "removed quick replies"