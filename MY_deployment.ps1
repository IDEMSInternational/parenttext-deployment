$source_file_name = "MY-plh-international-flavour"
$default_expiration_time = 60
$deployment = "malaysia"
$SPREADSHEET_ID_loc = '1rdEI_HWP7B_Q-J5ib9UYzDbbE4IWPbzA3-DfnGdZ0AM'
$CONFIG_ab_name = "ab_config"

$languages =  @("msa")
$2languages = @("ms")
$deployment_ = "malaysia"

$n_files = 2

.\parenttext_deployment_set_up_folders.ps1
.\parenttext_deployment_pipeline.ps1