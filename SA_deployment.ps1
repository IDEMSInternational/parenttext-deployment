$depl_prefix = "SA"
$prefix_list = "PLH;SA"
$default_expiration_time = 120 
$expiration_times =  ".\parenttext-international-repo\edits\expiration_times.json"
$deployment = "south-africa"
$SPREADSHEET_ID_loc = '1BZ6zKNwglzz8e3qhx1YCOMYxiSSnbDvRb3YxF-vvf_4'
$SPREADSHEET_ID_transl = '1xQWfDC2H322glS2qcobBd5_V0iOADQ1fcYNU4MCGxTw'
$CONFIG_ab_name = "ab_config_demo"

$replace_last_interaction = $false #replace in the campaigns with last_seen_on
$campaigns_to_remove = @() 

$languages =  @("afr","sot","tsn","xho","zul")
$2languages = @("af","st","tn","xh","zu")
$deployment_ = "south_africa"

$add_selectors = "yes"

$n_files = 2

.\parenttext_deployment_set_up_folders.ps1
.\parenttext_deployment_pipeline.ps1 