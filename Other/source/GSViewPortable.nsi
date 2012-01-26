SetCompress Auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize On
SilentInstall Silent
AutoCloseWindow True
RequestExecutionLevel user
OutFile "..\..\GSViewPortable.exe"
Icon "gsview.ico"

!include "FileFunc.nsh"
!insertmacro GetParameters

!macro _PathIfExist ARG1
  DetailPrint "Checking for ${ARG1}"
  StrCpy $9 ""
  IfFileExists "${ARG1}" 0 +4
  System::Call 'Kernel32::GetEnvironmentVariable(t , t, i) i("PATH", .r0, ${NSIS_MAX_STRLEN}).r1'
  System::Call 'Kernel32::SetEnvironmentVariableA(t, t) i("PATH", "${ARG1};$0").r3'StrCpy $9 "1"
!macroend
!define PathIfExist '!insertmacro "_PathIfExist"'


Section "Main" sec_main ; Checked
  ; Description:
  ; Main Section for GvEdit Launch
  IfFileExists "$EXEDIR\App\gsview\gsview32.exe" launch not_found
  launch:                               
    IfFileExists $EXEDIR\Data +2
    SetOutPath '$EXEDIR\Data'
    ${PathIfExist} "$EXEDIR\App\gsview"
    
    ${PathIfExist} "$EXEDIR\App\pstoedit"
    ${PathIfExist} "$EXEDIR\App\gm"

    ${PathIfExist} "$EXEDIR\App\gs9.04\bin"
    ;; BZR_HOME
    System::Call 'Kernel32::SetEnvironmentVariableA(t, t) i("GS_LIB", "$EXEDIR\App\gs9.04\lib").r3'
    System::Call 'Kernel32::SetEnvironmentVariableA(t, t) i("GS_DLL", "$EXEDIR\App\gs9.04\bin\gsdll32.dll").r3'
    System::Call 'Kernel32::SetEnvironmentVariableA(t, t) i("GS", "$EXEDIR\App\gs9.04\bin\gswin32c.exe").r3'
    ${GetParameters} $R1
    Exec "$EXEDIR\App\gsview\gsview32.exe /a $R1"
    Goto end
  not_found:
    MessageBox MB_OK "Could not find gsview32.exe. Installation corrupt."
  end:
  SectionEnd ; sec_main
  
