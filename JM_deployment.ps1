$depl_prefix = "JM"
$prefix_list = "PLH;JM"
$default_expiration_time = 60
$expiration_times =  ".\parenttext-jamaica-repo\edits\expiration_times_u_report.json"
$deployment = "jamaica"
$SPREADSHEET_ID_loc = '1YSHxIPfFJhf-jLzgd8P7-Y2-eIO_dc9jV7dkKBL1oXw'
$CONFIG_ab_name = "ab_config"

$remove_triggers = $true

$add_selectors = "yes"

$redefine_safeguarding = $true
$sg_flow_uuid = "b83315a6-b25c-413a-9aa0-953bf60f223c"
$sg_flow_name = "JM - PLH - Safeguarding - WFR interaction"

$replace_last_interaction = $false #replace in the campaigns with last_seen_on
$campaigns_to_remove = @("IPV follow up")

$languages =  @()
$2languages = @()
$deployment_ = "jamaica"

$n_files = 2

.\parenttext_deployment_set_up_folders.ps1
.\parenttext_deployment_pipeline.ps1




# edit u-report flows
$local_flows = ".\parenttext-jamaica-repo\flows\jamaica-development.json"
$edited_local_flows = ".\parenttext-jamaica-repo\temp\jamaica-development_edited.json"

# filter flows
node .\idems-chatbot-repo\scripts\filter_flows.js $local_flows $local_flows ".\parenttext-jamaica-repo\edits\jamaica_development_names.json" "name"

node .\idems-chatbot-repo\scripts\update_expiration_time.js $local_flows $expiration_times $default_expiration_time $edited_local_flows
Write-Output "Updated expiration u-report"

$triggers =  ".\parenttext-jamaica-repo\edits\triggers.json" 
node ..\safeguarding-rapidpro\add_triggers_to_flows.js  $edited_local_flows $triggers $edited_local_flows
Write-Output "Added triggers u-report"

