$source_file_name = "JM-plh-international-flavour"
$default_expiration_time = 60
$deployment = "jamaica"
$SPREADSHEET_ID_loc = '1YSHxIPfFJhf-jLzgd8P7-Y2-eIO_dc9jV7dkKBL1oXw'
$CONFIG_ab_name = "ab_config_demo"

$languages =  @()
$2languages = @()
$deployment_ = "jamaica"

$n_files = 2

.\parenttext_deployment_set_up_folders.ps1
.\parenttext_deployment_pipeline.ps1