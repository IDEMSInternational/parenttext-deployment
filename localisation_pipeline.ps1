$source_file_name = "plh-international-flavour"
$input_path_1 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-international-repo\flows\" + $source_file_name + ".json"


## localisation
Set-Location "C:\Users\fagio\Documents\rapidpro_abtesting"
$SPREADSHEET_ID = '1YSHxIPfFJhf-jLzgd8P7-Y2-eIO_dc9jV7dkKBL1oXw'
$JSON_FILENAME = $input_path_1
$source_file_name = $source_file_name + "_localised"
$output_path_3 = "C:\Users\fagio\Documents\parenttext-deployment\parenttext-jamaica-repo\temp\" + $source_file_name + ".json"
python main.py $JSON_FILENAME $output_path_3 $SPREADSHEET_ID --format google_sheets --logfile main_loc_jamaica.log
#python .\main_from_bash.py $SPREADSHEET_ID $JSON_FILENAME $output_path_3
Write-Output "localised flows"
Set-Location "C:\Users\fagio\Documents\parenttext-deployment"