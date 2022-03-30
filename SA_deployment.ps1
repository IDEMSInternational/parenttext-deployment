$source_file_name = "SA-plh-international-flavour"
$default_expiration_time = 60 
$deployment = "south-africa"
$SPREADSHEET_ID_loc = '1BZ6zKNwglzz8e3qhx1YCOMYxiSSnbDvRb3YxF-vvf_4'
$CONFIG_ab_name = "ab_config_demo"

$languages =  @("afr","sot","tsn","xho","zul")
$2languages = @("af","st","tn","xh","zu")
$deployment_ = "south_africa"

$n_files = 2

.\parenttext_deployment_set_up_folders.ps1
.\parenttext_deployment_pipeline.ps1 