$depl_prefix = "JM"
$default_expiration_time = 60
$deployment = "jamaica"
$SPREADSHEET_ID_loc = '1YSHxIPfFJhf-jLzgd8P7-Y2-eIO_dc9jV7dkKBL1oXw'
$CONFIG_ab_name = "ab_config_demo"
$remove_triggers = "yes"

$languages =  @()
$2languages = @()
$deployment_ = "jamaica"

$n_files = 2

.\parenttext_deployment_set_up_folders.ps1
.\parenttext_deployment_pipeline.ps1




# edit u-report flows
$local_flows = ".\parenttext-jamaica-repo\flows\jamaica-u-report-flows.json"
$edited_local_flows = ".\parenttext-jamaica-repo\temp\jamaica-u-report-flows_edited.json"


$expiration_times =  ".\parenttext-jamaica-repo\edits\expiration_times_u_report.json"
node .\idems-chatbot-repo\scripts\update_expiration_time.js $local_flows $expiration_times $default_expiration_time $edited_local_flows
Write-Output "updated expiration u-report"


$triggers =  ".\parenttext-jamaica-repo\edits\triggers.json" 
node ..\safeguarding-rapidpro\add_triggers_to_flows.js  $edited_local_flows $triggers $edited_local_flows
Write-Output "added triggers u-report"

# edit integration flows
$integration_flows = ".\parenttext-jamaica-repo\flows\jamaica-integration-flows.json"
$edited_integration_flows = ".\parenttext-jamaica-repo\temp\jamaica-integration-flows_edited.json"
node .\idems-chatbot-repo\scripts\update_expiration_time.js $integration_flows $expiration_times $default_expiration_time $edited_integration_flows
