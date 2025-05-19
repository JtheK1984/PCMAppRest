call "C:\Program Files (x86)\Embarcadero\Studio\23.0\bin\rsvars.bat"
echo "Build erstellen 32 Bit EXE"
msbuild E:/Projekte/Mobile/PCMManagerAPP-Rest/PCMManagerAPP.dproj /t:Clean;Build /p:config=Release /p:platform=Win32
echo "Build erstellen 32 Bit APK"
msbuild E:/Projekte/Mobile/PCMManagerAPP-Rest/PCMManagerAPP.dproj /p:config=Debug /p:platform=Android /t:Clean;Make;Deploy
echo "Build erstellen 64 Bit EXE"
msbuild E:/Projekte/Mobile/PCMManagerAPP-Rest/PCMManagerAPP.dproj /t:Clean;Build /p:config=Release /p:platform=Win64
echo "Build erstellen 64 Bit APK"
msbuild E:/Projekte/Mobile/PCMManagerAPP-Rest/PCMManagerAPP.dproj /p:config=Debug /p:platform=Android64 /t:Clean;Make;Deploy

echo "Kopiere Datei ins Setupverzeichnis 32-Bit"
copy /y /v E:\Projekte\Mobile\PCMManagerAPP-Rest\Android\Debug\PCMManagerAPP\bin\PCMManagerAPP.apk "e:\Inno\Setupfiles\Programme\PCMManagerAPPRest"
copy /y /v E:\Projekte\Mobile\PCMManagerAPP-Rest\Win32\Release\PCMManagerAPP.exe "e:\Inno\Setupfiles\Programme\PCMManagerAPPRest"

echo "Kopiere Datei ins Setupverzeichnis 64-Bit"
copy /y /v E:\Projekte\Mobile\PCMManagerAPP-Rest\Android64\Debug\PCMManagerAPP\bin\PCMManagerAPP.apk "e:\Inno\Setupfiles\Programme\PCMManagerAPPRest_x64"
copy /y /v E:\Projekte\Mobile\PCMManagerAPP-Rest\Win64\Release\PCMManagerAPP.exe "e:\Inno\Setupfiles\Programme\PCMManagerAPPRest_x64"

