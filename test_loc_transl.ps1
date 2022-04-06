# step 2: flow edits & A/B testing
$deployment = "south-africa"
$SPREADSHEET_ID_transl = '1xQWfDC2H322glS2qcobBd5_V0iOADQ1fcYNU4MCGxTw'
$output_path_1 = "parenttext-" + $deployment + "-repo\temp\SA-plh-international-flavour_expire_ABtesting_afr_sot_tsn_xho_zul.json"
$JSON_FILENAME = "..\parenttext-deployment\" + $output_path_1
$source_file_name = "SA-plh-international-flavour_expire_ABtesting_afr_sot_tsn_xho_zul" + "_edited"
$output_path_2 = "parenttext-" + $deployment + "-repo\temp\" + $source_file_name + ".json"
$transl_log = "..\parenttext-deployment\parenttext-" + $deployment + "-repo\temp\transl_warnings.log"
Set-Location "..\rapidpro_abtesting"
python main.py $JSON_FILENAME ("..\parenttext-deployment\" +$output_path_2) $SPREADSHEET_ID_transl --format google_sheets --logfile $transl_log
Write-Output "Edited translations"
Set-Location "..\parenttext-deployment"