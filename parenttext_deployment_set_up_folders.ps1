#create necessary folders
If(!(test-path ".\parenttext-international-repo\temp" ))
{
      New-Item -Path ".\parenttext-international-repo"  -Name ("temp" ) -ItemType "directory"
}


$temp_dir_parent = ".\parenttext-" + $deployment + "-repo"
$temp_dir = $temp_dir_parent + "\temp"
$temp_transl_dir_parent = ".\parenttext-" + $deployment + "-repo\temp" 
$temp_transl_dir = $temp_transl_dir_parent  + "\temp_transl"

If(!(test-path $temp_dir ))
{
      New-Item -Path $temp_dir_parent  -Name ("temp" ) -ItemType "directory"
      New-Item -Path $temp_dir_parent  -Name ("temp\temp_transl" ) -ItemType "directory"
}
else {
    If(!(test-path $temp_transl_dir ))
{
      New-Item -Path $temp_transl_dir_parent  -Name ("temp_transl" ) -ItemType "directory"
}
}

for ($i=0; $i -lt $languages.length; $i++) {
      $lang = $languages[$i]
      $temp_lang_dir = $temp_transl_dir + "\" + $lang
      If(!(test-path $temp_lang_dir ))
{
      New-Item -Path $temp_transl_dir  -Name ($lang ) -ItemType "directory"
}

}







