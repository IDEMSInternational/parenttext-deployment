$depl_prefix = "MY"
$prefix_list = "PLH;MY"
$default_expiration_time = 60
$expiration_times =  ".\parenttext-international-repo\edits\expiration_times.json"
$deployment = "malaysia"
$SPREADSHEET_ID_loc = '1rdEI_HWP7B_Q-J5ib9UYzDbbE4IWPbzA3-DfnGdZ0AM'
$CONFIG_ab_name = "ab_config"
$replace_last_interaction = $true #replace in the campaigns with last_seen_on
$campaigns_to_remove = @() 

$languages =  @("msa")
$2languages = @("ms")
$deployment_ = "malaysia"

$add_selectors = $false

$n_files = 2

.\parenttext_deployment_set_up_folders.ps1
.\parenttext_deployment_pipeline.ps1