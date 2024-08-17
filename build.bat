if not exist "./releases/passive skill trees" mkdir "./releases/passive skill trees"
if not exist "./releases/passive skill trees/resources" mkdir "./releases/passive skill trees/resources"
xcopy /s /y /i /exclude:build_exclude.txt "./resources" "./releases/passive skill trees/resources/"

if not exist "./releases/passive skill trees/scripts" mkdir "./releases/passive skill trees/scripts"
xcopy /s /y /i "./scripts" "./releases/passive skill trees/scripts/"

if not exist "./releases/passive skill trees/content" mkdir "./releases/passive skill trees/content"
xcopy /s /y /i "./content" "./releases/passive skill trees/content/"

xcopy /y /i "main.lua" "./releases/passive skill trees/main.lua"
xcopy /y /i "metadata.xml" "./releases/passive skill trees/metadata.xml"
xcopy /y /i "PST_config.lua" "./releases/passive skill trees/PST_config.lua"
xcopy /y /i "thumb.png" "./releases/passive skill trees/thumb.png"