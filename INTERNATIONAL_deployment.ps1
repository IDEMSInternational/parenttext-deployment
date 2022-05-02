$depl_prefix = ""
$default_expiration_time = 60
$deployment = "international"
$SPREADSHEET_ID_loc = ''
$CONFIG_ab_name = "ab_config"

$languages =  @()
$2languages = @()
$deployment_ = "international"

$n_files = 2

.\parenttext_deployment_set_up_folders.ps1
.\parenttext_deployment_pipeline.ps1