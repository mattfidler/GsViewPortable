CRCCheck On
RequestExecutionLevel user

; Best Compression
SetCompress Auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize On
;SetCompress off



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

!define MUI_COMPONENTSPAGE_SMALLDESC

OutFile "..\..\GsView-4.9-Net-Installer.exe"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENCE"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_LANGUAGE "English"

Section "GSViewPortable" sec_gsviewportable ; Checked
  ; Description:
  ; GsViewPortable
  RmDir /r "$INSTDIR"
  inetc::get "http://mirror.cs.wisc.edu/pub/mirrors/ghost/ghostgum/gsv49w32.exe" \
      "$TEMP\gsview49.zip"
  ZipDLL::extractall "$TEMP\gsview49.zip" "$INSTDIR"
  Delete "$TEMP\gsview49.zip"
  Delete "$INSTDIR\setup.exe"
  Delete "$INSTDIR\*.dll"
  Delete "$INSTDIR\*.DIZ"
  Delete "$INSTDIR\filelist.txt"
  inetc::get "http://mirror.cs.wisc.edu/pub/mirrors/ghost/GPL/gs864/gs864w32.exe" \
      "$TEMP\gs864.zip"
  ZipDLL::extractall "$TEMP\gs864.zip" "$INSTDIR"
  Delete "$TEMP\gs864.zip"
  Delete "$INSTDIR\filelist.txt"
  Delete "$INSTDIR\setupgs.exe"
  Delete "$INSTDIR\uninstgs.exe"
  
SectionEnd ; sec_gsviewportable

;--------------------------------
;Description(s)
LangString DESC_sec_gsviewportable ${LANG_ENGLISH} "GsViewPortable"
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
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
  StrCpy $PA ""
  ${GetDrives} "FDD+HDD" "GetDriveVars"
  StrCpy $INSTDIR "$PA\GSViewPortable"
FunctionEnd
