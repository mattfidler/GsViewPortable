CRCCheck On
RequestExecutionLevel user

; Best Compression
SetCompress Auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize On
;SetCompress off
!define inno "..\..\..\CommonFiles\bin\innounp.exe"


; MUI2
!include "MUI2.nsh"
!include "FileFunc.nsh"
Name "GSView Portable"
BrandingText "GSView Portable"

!define MUI_ICON "gsview.ico"

;automatically close the installer when done.
AutoCloseWindow true
!define MUI_HEADERIMAGE

!define MUI_PAGE_HEADER_TEXT "GSView Portable"
!define MUI_PAGE_HEADER_SUBTEXT "GSView on the Go"

OutFile "..\..\GsView-4.9-1-Net-Installer.exe"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENCE"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_LANGUAGE "English"

Section "GSViewPortable" sec_gsviewportable ; Checked
  ; Description:
  ; GsViewPortable
  RmDir /r "$INSTDIR"
  SetOutPath "$INSTDIR"
  File "..\..\GSViewPortable.exe"
  File "..\..\help.html"
  
  inetc::get "http://mirror.cs.wisc.edu/pub/mirrors/ghost/ghostgum/gsv49w32.exe" \
      "$TEMP\gsview49.zip"
  ZipDLL::extractall "$TEMP\gsview49.zip" "$INSTDIR\App"
  Delete "$TEMP\gsview49.zip"
  Delete "$INSTDIR\App\setup.exe"
  Delete "$INSTDIR\App\*.dll"
  Delete "$INSTDIR\App\*.DIZ"
  Delete "$INSTDIR\App\filelist.txt"
  inetc::get "http://mirror.cs.wisc.edu/pub/mirrors/ghost/GPL/gs864/gs864w32.exe" \
      "$TEMP\gs864.zip"
  ZipDLL::extractall "$TEMP\gs864.zip" "$INSTDIR\App"
  RmDir /r "$INSTDIR\App\gs8.64\examples"
  Delete "$TEMP\gs864.zip"
  Delete "$INSTDIR\App\filelist.txt"
  Delete "$INSTDIR\App\setupgs.exe"
  Delete "$INSTDIR\App\uninstgs.exe"  
SectionEnd ; sec_gsviewportable
Section "pstoedit" sec_pstoedit ; Checked
  ; Description:
  ; pstoedit translates PostScript and PDF graphics into other vector formats. 
  inetc::get "http://downloads.sourceforge.net/project/pstoedit/pstoedit/3.60/pstoeditsetup_win32.exe" "$TEMP\pstoedit.exe"
  ExecDos::exec "$PLUGINSDIR\innounp.exe -x $TEMP\pstoedit.exe -d$TEMP\pstoedit"
  Delete "$TEMP\pstoedit.exe"
  Delete "$TEMP\pstoedit\{app}\drvmagick.dll"
  RmDir /r "$TEMP\pstoedit\{app}\importps"
  RmDir /r "$TEMP\pstoedit\{app}\include"
  RmDir /r "$TEMP\pstoedit\{app}\examples"
  CopyFiles /SILENT "$TEMP\pstoedit\{app}" "$INSTDIR\App\"
  Rename "$INSTDIR\App\{app}" "$INSTDIR\App\pstoedit"
  RmDir /r "$TEMP\pstoedit"
SectionEnd ; sec_pstoedit

;--------------------------------
;Description(s)
LangString DESC_sec_gsviewportable ${LANG_ENGLISH} "GsViewPortable"
LangString DESC_sec_pstoedit ${LANG_ENGLISH} "pstoedit translates PostScript and PDF graphics into other vector formats. "
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${sec_pstoedit} $(DESC_sec_pstoedit)
  !insertmacro MUI_DESCRIPTION_TEXT ${sec_gsviewportable} $(DESC_sec_gsviewportable)
!insertmacro MUI_FUNCTION_DESCRIPTION_END


Var PA
Function GetDriveVars
  StrCmp $9 "c:\" spa
  StrCmp $8 "HDD" gpa
  StrCmp $9 "a:\" spa
  StrCmp $9 "b:\" spa
  
  gpa:
    IfFileExists "$9PortableApps" 0 spa
    StrCpy $PA "$9PortableApps"
  spa:
    Push $0
    
FunctionEnd
Function .onInit
  IntOp $0 ${SF_RO} | ${SF_SELECTED}
  SectionSetFlags ${sec_gsviewportable} $0
  StrCpy $PA ""
  ${GetDrives} "FDD+HDD" "GetDriveVars"
  StrCpy $INSTDIR "$PA\GSViewPortable"
  InitPluginsDir
  SetOutPath "$PLUGINSDIR"
  File ${inno}
FunctionEnd
Function .onGUIEnd
  RmDir /r $PLUGINSDIR
FunctionEnd
