$depl_prefix = "TH"
$prefix_list = "PLH;TH"
$default_expiration_time = 120
$deployment = "thailand"
$expiration_times =  ".\parenttext-thailand-repo\edits\expiration_times.json"
$SPREADSHEET_ID_loc = '11l2fdhY9wEwQphevpiJS2YmA4xLtXAEr7dlesmsMoKg'
$CONFIG_ab_name = "ab_config_demo"

$replace_last_interaction = $false #replace in the campaigns with last_seen_on
$campaigns_to_remove = @("Remove inactive users from program") 

$replace_uncaught_trigger = $false

$languages =  @()
$2languages = @()
<#
$languages =  @("tha")
$2languages = @("th")
#>
$deployment_ = "thailand"

$add_selectors = "yes"

$n_files = 2

.\parenttext_deployment_set_up_folders.ps1
.\parenttext_deployment_pipeline.ps1


$demo_flows = ".\parenttext-thailand-repo\temp\thailand_flows_in_demo.json"
$output_flows = ".\parenttext-thailand-repo\temp\TH-plh-international-flavour_expire_ABtesting.json"
# filter flows for translation of demo
node .\idems-chatbot-repo\scripts\filter_flows.js $output_flows $demo_flows ".\parenttext-thailand-repo\edits\list_of_flows.json" "-name"