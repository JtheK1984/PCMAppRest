echo "Kopiere Datei ins Setupverzeichnis"
copy /y /v Win32\Release\PCMManagerAPP.exe "e:\Inno\Setupfiles\Programme\PCMManagerAPPRest"
copy /y /v Win64\Release\PCMManagerAPP.exe "e:\Inno\Setupfiles\Programme\PCMManagerAPPRest_x64"
copy /y /v Android\Debug\PCMManagerAPP\bin\PCMManagerAPP.apk "e:\Inno\Setupfiles\Programme\PCMManagerAPPRest"
copy /y /v Android64\Debug\PCMManagerAPP\bin\PCMManagerAPP.apk "e:\Inno\Setupfiles\Programme\PCMManagerAPPRest_x64"


