$source_file_name = "PH-plh-international-flavour"
$default_expiration_time = 60
$deployment = "philippines"
$SPREADSHEET_ID_loc = '1oEdmUA5W_knyji8Ps-5Tw2SkRTWLNMHNuLpgLSuWgXA'
$CONFIG_ab_name = "ab_config"

$languages =  @("fil")
$2languages = @("fil")
$deployment_ = "philippines"

$n_files = 2

.\parenttext_deployment_set_up_folders.ps1
.\parenttext_deployment_pipeline.ps1