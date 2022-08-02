$depl_prefix = "PH"
$default_expiration_time = 60
$deployment = "philippines"
$expiration_times =  ".\parenttext-philippines-repo\edits\expiration_times.json"
$SPREADSHEET_ID_loc = '1oEdmUA5W_knyji8Ps-5Tw2SkRTWLNMHNuLpgLSuWgXA'
$CONFIG_ab_name = "ab_config"

$replace_last_interaction = $false #replace in the campaigns with last_seen_on
$campaigns_to_remove = @("Remove inactive users from program") 

$replace_uncaught_trigger = $true
$uncaught_flow_uuid = "d657f33f-c512-4546-82e2-5cf1370586ce"
$uncaught_flow_name = "PH - PLH - Internal - Wrapper - Handle uncaught messages"

$languages =  @("fil")
$2languages = @("fil")
$deployment_ = "philippines"

$add_selectors = "yes"

$n_files = 2

.\parenttext_deployment_set_up_folders.ps1
.\parenttext_deployment_pipeline.ps1