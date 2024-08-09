if not exist "../passive skill trees" mkdir "../passive skill trees"
if not exist "../passive skill trees/resources" mkdir "../passive skill trees/resources"
xcopy /s /y /i /exclude:build_exclude.txt "./resources" "../passive skill trees/resources/"

if not exist "../passive skill trees/scripts" mkdir "../passive skill trees/scripts"
xcopy /s /y /i "./scripts" "../passive skill trees/scripts/"

xcopy /y /i "main.lua" "../passive skill trees/main.lua"
xcopy /y /i "metadata.xml" "../passive skill trees/metadata.xml"
xcopy /y /i "PST_config.lua" "../passive skill trees/PST_config.lua"
xcopy /y /i "thumb.png" "../passive skill trees/thumb.png"