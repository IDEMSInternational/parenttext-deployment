$depl_prefix = ""
$prefix_list = "PLH"
$default_expiration_time = 60
$expiration_times =  ".\parenttext-international-repo\edits\expiration_times.json"
$deployment = "international"
$SPREADSHEET_ID_loc = ''
$CONFIG_ab_name = "ab_config"

$replace_last_interaction = $false #replace in the campaigns with last_seen_on
$campaigns_to_remove = @() 

$languages =  @()
$2languages = @()
$deployment_ = "international"

$add_selectors = $false

$n_files = 2

.\parenttext_deployment_set_up_folders.ps1
.\parenttext_deployment_pipeline.ps1