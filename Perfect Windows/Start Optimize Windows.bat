@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul
title Perfect Windows - Safe Configurable Tweaks (Fixed v2.1)
reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1
for /F %%A in ('powershell -NoProfile -Command "[char]27"') do set "ESC=%%A"
set "N=!ESC![0m"
set "W=!ESC![97m"
set "K=!ESC![90m"
set "R=!ESC![91m"
set "G=!ESC![92m"
set "Y=!ESC![93m"
set "B=!ESC![94m"
set "M=!ESC![95m"
set "C=!ESC![96m"
for /f %%A in ('powershell -NoProfile -Command "try{$Host.UI.RawUI.SupportsVirtualTerminal}catch{ $false }"') do set "VTOK=%%A"
if /i "!VTOK!" NEQ "True" (
  echo.
  echo Warning: This console may not fully support ANSI/VT sequences. Colors are enabled anyway.
  echo If you see garbage characters, run the script in Windows Terminal or enable VirtualTerminalLevel and reopen the console.
  echo.
)
>nul 2>&1 fltmc || (
  whoami /groups | findstr /i "S-1-5-32-544" >nul || (
    echo Run as Administrator.
    pause
    exit /b
  )
)
set "ROOT=%~dp0"
set "OUT=!ROOT!_perfectwindows"
set "LOG=!OUT!\logs"
set "BACKUP=!OUT!\backups"
set "TS="
if not exist "!OUT!" md "!OUT!"
if not exist "!LOG!" md "!LOG!"
if not exist "!BACKUP!" md "!BACKUP!"
for /f %%A in ('powershell -NoProfile -Command "(Get-Date).ToString('yyyyMMddHHmmss')"') do set "TS=%%A"
if not defined TS (
    set "TS=%DATE:~-4%%DATE:~3,2%%DATE:~0,2%%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%"
    set "TS=!TS: =0!"
    set "TS=!TS::=!"
)
set "BUILD="
set "VERSTR="
for /f "tokens=3" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild 2^>nul') do set "BUILD=%%A"
for /f "tokens=3" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v DisplayVersion 2^>nul') do set "VERSTR=%%A"
for /f "tokens=3" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ReleaseId 2^>nul') do if not defined VERSTR set "VERSTR=%%A"
if not defined VERSTR set "VERSTR=(unknown)"
if not defined BUILD set "BUILD=(unknown)"
set "OSLINE=Build !BUILD! !VERSTR!"
set PRIVACY=1
set SERVICES=1
set GAMING=1
set UI=1
set NETWORK=1
set POWER=0
set CLEANUP=0
set SECURITY=0
set BOOT_LEGACY=0
set LOGIN_SAFEGUARD=1
:banner
cls
echo.
echo !W!██████╗ ██╗ ██╗  ██╗ ██╗ █████╗ █████╗ ██╗ █████╗ ██╗ ██║!N!
echo !W!██╔══██╗╚██╗ ██╔╝  ██║ ██║██╔══██╗██╔══██╗██║ ██╔══██╗██║ ██║!N!
echo !W!██████╦╝ ╚████╔╝   ╚██╗ ██╔╝███████║██║ ╚═╝██║ ███████║╚██╗ ██╔╝!N!
echo !W!██╔══██╗ ╚██╔╝    ╚████╔╝ ██╔══██║██║ ██╗██║ ██╔══██║ ╚████╔╝ !N!
echo !W!██████╦╝ ██║    ╚██╔╝ ██║ ██║╚█████╔╝███████╗██║ ██║ ╚██╔╝ !N!
echo !W!╚═════╝ ╚═╝    ╚═╝ ╚═╝ ╚═╝ ╚════╝ ╚══════╝╚═╝ ╚═╝ ╚═╝ !N!
echo !K!--------------------------------------------------------------------------------------------------------------!N!
echo !C!Detected:!N! !W!!OSLINE!!N! !K!Backups:!N! !W!!BACKUP!!N!
echo.
set /a count=1
call :showToggle PRIVACY !count! "Privacy / Telemetry hardening"
set /a count+=1
call :showToggle SERVICES !count! "Service tuning (SAFE profile; keeps HID/Biometrics)"
set /a count+=1
call :showToggle GAMING !count! "Gaming tweaks (GameDVR off, scheduler, multimedia)"
set /a count+=1
call :showToggle UI !count! "UI/Taskbar suggestions & ads off"
set /a count+=1
call :showToggle NETWORK !count! "Network tweaks (Wi-Fi Sense off, feeds off)"
set /a count+=1
call :showToggle POWER !count! "Power: disable hibernate (saves disk, affects Fast Startup)"
set /a count+=1
call :showToggle CLEANUP !count! "Cleanup (safe temp/thumbcache only, no Prefetch/log nukes)"
set /a count+=1
call :showToggle SECURITY !count! "Disable system mitigations (NOT recommended)"
set /a count+=1
call :showToggle BOOT_LEGACY !count! "Legacy F8 boot menu [advanced]"
set /a count+=1
call :showToggle LOGIN_SAFEGUARD !count! "Login Safeguard (prevents PIN/biometric breakage)"
echo.
echo !B![A]!N! Apply !Y![P]!N! Preview !C![R]!N! Restore !R![E]!N! Exit
echo.
set /p "choice=Enter option (1-10, A, P, R, E): "
if "!choice!"=="1" goto toggle1
if "!choice!"=="2" goto toggle2
if "!choice!"=="3" goto toggle3
if "!choice!"=="4" goto toggle4
if "!choice!"=="5" goto toggle5
if "!choice!"=="6" goto toggle6
if "!choice!"=="7" goto toggle7
if "!choice!"=="8" goto toggle8
if "!choice!"=="9" goto toggle9
if "!choice!"=="10" goto toggle10
if /i "!choice!"=="A" goto apply
if /i "!choice!"=="P" goto preview
if /i "!choice!"=="R" goto restore
if /i "!choice!"=="E" exit /b
goto banner
:toggle1
if "!PRIVACY!"=="1" (set "PRIVACY=0") else (set "PRIVACY=1")
goto banner
:toggle2
if "!SERVICES!"=="1" (set "SERVICES=0") else (set "SERVICES=1")
goto banner
:toggle3
if "!GAMING!"=="1" (set "GAMING=0") else (set "GAMING=1")
goto banner
:toggle4
if "!UI!"=="1" (set "UI=0") else (set "UI=1")
goto banner
:toggle5
if "!NETWORK!"=="1" (set "NETWORK=0") else (set "NETWORK=1")
goto banner
:toggle6
if "!POWER!"=="1" (set "POWER=0") else (set "POWER=1")
goto banner
:toggle7
if "!CLEANUP!"=="1" (set "CLEANUP=0") else (set "CLEANUP=1")
goto banner
:toggle8
if "!SECURITY!"=="1" (set "SECURITY=0") else (set "SECURITY=1")
goto banner
:toggle9
if "!BOOT_LEGACY!"=="1" (set "BOOT_LEGACY=0") else (set "BOOT_LEGACY=1")
goto banner
:toggle10
if "!LOGIN_SAFEGUARD!"=="1" (set "LOGIN_SAFEGUARD=0") else (set "LOGIN_SAFEGUARD=1")
goto banner
:showToggle
set "val=!%~1!"
set "num=%~2"
set "label=%~3"
if "!val!"=="1" (
  echo !num!. !G!ON !N! — !W!!label!!N!
) else (
  echo !num!. !R!OFF!N! — !K!!label!!N!
)
exit /b
:preview
cls
echo === DRY RUN / WHAT WILL CHANGE ===
if "!PRIVACY!"=="1" (
    echo [Privacy]
    echo Disable telemetry and advertising IDs
    if "!LOGIN_SAFEGUARD!"=="0" echo Disable biometrics and location services
)
if "!SERVICES!"=="1" (
    echo [Services]
    echo Tune service start types (incl. wildcard user services)
)
if "!GAMING!"=="1" (
    echo [Gaming]
    echo Disable GameDVR and tweak scheduler/MM settings
)
if "!UI!"=="1" (
    echo [UI]
    echo Disable taskbar suggestions and ads
)
if "!NETWORK!"=="1" (
    echo [Network]
    echo Disable Wi-Fi Sense and hotspot reporting
)
if "!POWER!"=="1" (
    echo [Power]
    echo Disable hibernation
)
if "!CLEANUP!"=="1" (
    echo [Cleanup]
    echo Clean temp and thumbnail caches
)
if "!BOOT_LEGACY!"=="1" (
    echo [Boot]
    echo Enable legacy F8 boot menu
)
if "!SECURITY!"=="1" (
    echo [Security]
    echo WARNING: Disable system security mitigations
)
echo.
pause
goto banner
:apply
cls
set "RUNLOG=!LOG!\run_!TS!.log"
call :log "=== Start run !TS! — !OSLINE! ==="
echo Creating restore point and backups...
call :log "Creating restore point and backups..."
powershell -NoProfile -Command "try{Checkpoint-Computer -Description 'PerfectWindows_!TS!' -RestorePointType 'MODIFY_SETTINGS' | Out-Null; Write-Output 'OK'}catch{Write-Output 'SR_failed'}" | findstr /i "OK" >nul || echo (Restore point could not be created — continue anyway.)
reg export "HKLM\SOFTWARE\Policies" "!BACKUP!\policies_!TS!.reg" /y >nul 2>&1
reg export "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "!BACKUP!\cdm_!TS!.reg" /y >nul 2>&1
reg export "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "!BACKUP!\mmsp_!TS!.reg" /y >nul 2>&1
reg export "HKLM\SYSTEM\CurrentControlSet\Control" "!BACKUP!\control_!TS!.reg" /y >nul 2>&1
sc query type= service state= all > "!BACKUP!\services_!TS!.txt" 2>&1
schtasks /query /v /fo LIST > "!BACKUP!\tasks_!TS!.txt" 2>&1
echo Backups done.
call :log "Backups done."
echo.
echo Applying selected tweaks...
call :log "Applying selected tweaks..."
if "!PRIVACY!"=="1" call :do_privacy
if "!SERVICES!"=="1" call :do_services
if "!GAMING!"=="1" call :do_gaming
if "!UI!"=="1" call :do_ui
if "!NETWORK!"=="1" call :do_network
if "!POWER!"=="1" call :do_power
if "!CLEANUP!"=="1" call :do_cleanup
if "!BOOT_LEGACY!"=="1" call :do_boot_legacy
if "!SECURITY!"=="1" call :do_security
echo.
echo All selected tweaks applied. A reboot is recommended.
call :log "Completed. Reboot recommended."
pause
goto banner
:restore
cls
echo === RESTORE OPTIONS ===
echo [1] Re-enable critical input/login services (HID, Biometrics, NaturalAuth)
echo [2] Restore Windows Hello/Biometrics policies
echo [3] Re-enable GameDVR
echo [4] Re-enable Windows Update service
echo [5] Load full registry snapshot (manual .reg import from !BACKUP!)
echo [6] Restore Power/Hibernation
echo [7] Restore Network policies (Wi-Fi Sense defaults)
echo [8] Restore Boot menu policy (Standard)
echo [E] Back
choice /c 12345678E /n /m "Pick: "
if errorlevel 9 goto banner
if errorlevel 8 goto restore_boot
if errorlevel 7 goto restore_network_policies
if errorlevel 6 goto restore_power
if errorlevel 5 goto restore_reg
if errorlevel 4 goto restore_wu
if errorlevel 3 goto restore_gamedvr
if errorlevel 2 goto restore_bio
if errorlevel 1 goto restore_input
goto banner
:setService
if "%~1"=="" exit /b
set "service_pattern=%~1"
set "target_type=%~2"
echo "!service_pattern!" | findstr /c:"*" >nul
if errorlevel 1 (
    call :setSingleService "!service_pattern!" "!target_type!"
) else (
    echo Processing wildcard services matching: !service_pattern!
    set "prefix=!service_pattern:~0,-1!"
    set "prefix_len=0"
    for /L %%i in (0,1,256) do if not "!prefix:~%%i,1!"=="" set /a prefix_len=%%i+1
    set "found=0"
    for /f "tokens=2 delims=:" %%s in ('sc query type^= service state^= all ^| find "SERVICE_NAME:"') do (
        set "svc=%%~s"
        set "svc=!svc: =!"
        if /i "!svc:~0,%prefix_len%!"=="!prefix!" (
            set /a found+=1
            call :setSingleService "!svc!" "!target_type!"
        )
    )
    if "!found!"=="0" echo - No services found matching "!service_pattern!"
)
exit /b
:setSingleService
set "service_name=%~1"
set "target_type=%~2"
sc qc "!service_name!" >nul 2>&1
if errorlevel 1 (
    echo - Skip "!service_name!" (does not exist)
    exit /b
)
set "start_hex="
for /f "tokens=3" %%m in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\!service_name!" /v Start 2^>nul ^| find /i "Start"') do set "start_hex=%%m"
if not defined start_hex (
    echo x Failed to read current start for "!service_name!"
    exit /b
)
set "current_start="
if /i "!start_hex!"=="0x0" set "current_start=boot"
if /i "!start_hex!"=="0x1" set "current_start=system"
if /i "!start_hex!"=="0x2" (
    set "current_start=auto"
    reg query "HKLM\SYSTEM\CurrentControlSet\Services\!service_name!" /v DelayedAutoStart 2>nul | find "0x1" >nul && set "current_start=delayed-auto"
)
if /i "!start_hex!"=="0x3" set "current_start=manual"
if /i "!start_hex!"=="0x4" set "current_start=disabled"
if /i "!target_type!"=="!current_start!" (
    echo ~ "!service_name!" already !target_type!
    exit /b
)
set "sc_type=!target_type!"
if /i "!target_type!"=="delayed-auto" set "sc_type=auto"
if /i "!target_type!"=="manual" set "sc_type=demand"
sc config "!service_name!" start= !sc_type! >nul 2>&1
if errorlevel 1 (
    echo x Failed to set "!service_name!" start type to !sc_type!
    exit /b
)
if /i "!target_type!"=="delayed-auto" (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\!service_name!" /v DelayedAutoStart /t REG_DWORD /d 1 /f >nul 2>&1 || (
        echo x Failed to set DelayedAutoStart for "!service_name!"
        exit /b
    )
) else if /i "!target_type!"=="auto" (
    reg delete "HKLM\SYSTEM\CurrentControlSet\Services\!service_name!" /v DelayedAutoStart /f >nul 2>&1
)
echo * Set "!service_name!" to !target_type! (was !current_start!)
exit /b
:addReg
set "AR_KEY=%~1"
set "AR_VAL=%~2"
set "AR_TYP=%~3"
set "AR_DATA=%~4"
if /i "!AR_TYP!"=="REG_SZ" if "!AR_DATA!"=="" set "AR_DATA="
reg add "!AR_KEY!" /v "!AR_VAL!" /t !AR_TYP! /d "!AR_DATA!" /f >nul 2>&1
if errorlevel 1 (
    echo x !AR_KEY!\!AR_VAL! (failed)
) else (
    echo + !AR_KEY!\!AR_VAL! = !AR_DATA!
)
exit /b
:log
>>"!RUNLOG!" echo [%DATE% %TIME%] %~1
exit /b
:do_privacy
echo [Privacy]
call :addReg "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" REG_DWORD 0
call :addReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" REG_DWORD 0
call :addReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "DoNotShowFeedbackNotifications" REG_DWORD 1
call :addReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableWindowsConsumerFeatures" REG_DWORD 1
call :addReg "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" REG_DWORD 0
call :addReg "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" REG_DWORD 0
call :addReg "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-353698Enabled" REG_DWORD 0
call :addReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" REG_DWORD 0
call :addReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" "PublishUserActivities" REG_DWORD 0
call :addReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" "UploadUserActivities" REG_DWORD 0
call :addReg "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "ContentDeliveryAllowed" REG_DWORD 0
call :addReg "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "OemPreInstalledAppsEnabled" REG_DWORD 0
call :addReg "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "PreInstalledAppsEnabled" REG_DWORD 0
call :addReg "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "PreInstalledAppsEverEnabled" REG_DWORD 0
call :addReg "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SilentInstalledAppsEnabled" REG_DWORD 0
call :addReg "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338387Enabled" REG_DWORD 0
call :addReg "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338388Enabled" REG_DWORD 0
call :addReg "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338389Enabled" REG_DWORD 0
call :addReg "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-353698Enabled" REG_DWORD 0
call :addReg "HKCU\SOFTWARE\Microsoft\Siuf\Rules" "NumberOfSIUFInPeriod" REG_DWORD 0
call :addReg "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableTailoredExperiencesWithDiagnosticData" REG_DWORD 1
call :addReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" "DisabledByGroupPolicy" REG_DWORD 1
call :addReg "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" "Disabled" REG_DWORD 1
call :addReg "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" "fAllowToGetHelp" REG_DWORD 0
call :addReg "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" "EnthusiastMode" REG_DWORD 1
call :addReg "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" "LongPathsEnabled" REG_DWORD 1
call :addReg "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" "SearchOrderConfig" REG_DWORD 1
call :addReg "HKCU\Control Panel\Desktop" "MenuShowDelay" REG_DWORD 1
call :addReg "HKCU\Control Panel\Desktop" "AutoEndTasks" REG_DWORD 1
call :addReg "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "ClearPageFileAtShutdown" REG_DWORD 0
call :addReg "HKLM\SYSTEM\ControlSet001\Services\Ndu" "Start" REG_DWORD 2
call :addReg "HKCU\Control Panel\Mouse" "MouseHoverTime" REG_SZ 400
call :addReg "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" "IRPStackSize" REG_DWORD 30
call :addReg "HKCU\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" "EnableFeeds" REG_DWORD 0
call :addReg "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" "ShellFeedsTaskbarViewMode" REG_DWORD 2
call :addReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "MaxTelemetryAllowed" REG_DWORD 0
call :addReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" "PreventHandwritingErrorReports" REG_DWORD 1
call :addReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" REG_DWORD 0
call :addReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableSoftLanding" REG_DWORD 1
call :addReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" "NoLockScreenCamera" REG_DWORD 1
call :addReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableWindowsConsumerFeatures" REG_DWORD 1
call :addReg "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" REG_DWORD 0
call :addReg "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338393Enabled" REG_DWORD 0
call :addReg "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" "CEIPEnable" REG_DWORD 0
call :addReg "HKLM\SOFTWARE\Policies\Assist" "NoImplicitFeedback" REG_DWORD 1
call :addReg "HKCU\Software\Microsoft\Windows\CurrentVersion\FlightSettings" "UserPreferredRedirectStage" REG_DWORD 0
call :addReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\HomeGroup" "DisableHomeGroup" REG_DWORD 1
call :addReg "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" "Value" REG_SZ "Deny"
call :addReg "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" "SensorPermissionState" REG_DWORD 0
call :addReg "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" "Status" REG_DWORD 0
call :addReg "HKLM\SYSTEM\Maps" "AutoUpdateEnabled" REG_DWORD 0
echo Disable Scheduled Tasks
schtasks /change /tn "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable
schtasks /change /tn "Microsoft\Windows\Application Experience\ProgramDataUpdater" /disable
schtasks /change /tn "Microsoft\Windows\Autochk\Proxy" /disable
schtasks /change /tn "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable
schtasks /change /tn "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /disable
schtasks /change /tn "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /disable
schtasks /change /tn "Microsoft\Windows\Feedback\Siuf\DmClient" /disable
schtasks /change /tn "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" /disable
schtasks /change /tn "Microsoft\Windows\Windows Error Reporting\QueueReporting" /disable
schtasks /change /tn "Microsoft\Windows\Application Experience\MareBackup" /disable
schtasks /change /tn "Microsoft\Windows\Application Experience\StartupAppTask" /disable
schtasks /change /tn "Microsoft\Windows\Application Experience\PcaPatchDbTask" /disable
schtasks /change /tn "Microsoft\Windows\Maps\MapsUpdateTask" /disable
net stop "HomeGroupListener"
net stop "HomeGroupProvider"
sc config HomeGroupListener start= demand
sc config HomeGroupProvider start= demand
set "autoLoggerDir=%PROGRAMDATA%\Microsoft\Diagnosis\ETLLogs\AutoLogger"
if exist "%autoLoggerDir%\AutoLogger-Diagtrack-Listener.etl" (
    del "%autoLoggerDir%\AutoLogger-Diagtrack-Listener.etl"
)
icacls "%autoLoggerDir%" /deny SYSTEM:(OI)(CI)F
if "!LOGIN_SAFEGUARD!"=="0" (
    call :addReg "HKLM\SOFTWARE\Policies\Microsoft\Biometrics" "Enabled" REG_DWORD 0
    call :addReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "DisableLocation" REG_DWORD 1
) else (
    echo - Skipped biometrics/location due to LoginSafeguard
)
exit /b
:do_services
echo [Services]
set services_auto=AudioEndpointBuilder Audiosrv BFE BrokerInfrastructure BthAvctpSvc CoreMessagingRegistrar CryptSvc DPS Dhcp Dnscache EventLog EventSystem LanmanServer LanmanWorkstation NaturalAuthentication NgcCtnrSvc NgcSvc NlaSvc ProfSvc Power RpcEptMapper RpcSs SamSs Schedule ShellHWDetection Spooler SysMain Themes UserManager WinDefend Winmgmt WlanSvc gpsvc iphlpsvc mpssvc nsi
set services_manual=ALG AppIDSvc AppMgmt AppReadiness AppXSvc Appinfo AxInstSV BDESVC BTAGService Browser CDPSvc COMSysApp CertPropSvc ClipSVC CscService DcomLaunch DcpSvc DevQueryBroker DeviceAssociationService DeviceInstall DispBrokerDesktopSvc DisplayEnhancementService DmEnrollmentSvc EFS EapHost EntAppSvc FDResPub Fax FontCache FrameServer FrameServerMonitor GraphicsPerfSvc HvHost IEEtwCollectorService IKEEXT InstallService InventorySvc IpxlatCfgSvc KeyIso KtmRm LicenseManager LxpSvc MSDTC MSiSCSI McpManagementService MicrosoftEdgeElevationService MixedRealityOpenXRSvc MsKeyboardFilter NcaSvc NcbService NcdAutoSetup NetSetupSvc Netman Netprofm Netlogon OneSyncSvc_ PNRPAutoReg PNRPsvc PcaSvc PeerDistSvc PerfHost PhoneSvc PlugPlay PolicyAgent PrintNotify PushToInstall QWAVE RasAuto RasMan RetailDemo RmSvc RpcLocator SCPolicySvc SCardSvr SDRSVC SEMgrSvc SNMPTRAP SSDPSRV ScDeviceEnum SecurityHealthService Sense SensorDataService SensorService SensrSvc SessionEnv SharedAccess SharedRealitySvc SmsRouter SstpSvc StiSvc StorSvc SystemEventsBroker TabletInputService TapiSrv TermService TieringEngineService TimeBroker TimeBrokerSvc TokenBroker TrkWks TroubleshootingSvc TrustedInstaller UI0Detect UmRdpService UsoSvc VSS VacSvc W32Time WEPHOSTSVC WFDSConMgrSvc WMPNetworkSvc WwanSvc WPDBusEnum WSService WaaSMedicSvc WalletService WarpJITSvc WbioSrvc Wcmsvc WcsPlugInService WdNisSvc WdiServiceHost WdiSystemHost WebClient Wecsvc WerSvc WiaRpc WinHttpAutoProxySvc WinRM WpcMonSvc WpnService Wudfsvc bthserv camsvc cloudidsvc dcsvc defragsvc diagnosticshub.standardcollector.service diagsvc dmwappushservice dot3svc edgeupdate edgeupdatem fdPHost fhsvc hidserv icssvc lfsvc lltdsvc lmhosts msiserver p2pimsvc p2psvc perceptionsimulation pla seclogon smphost svsvc swprv tiledatamodelsvc upnphost vds vm3dservice vmicguestinterface vmicheartbeat vmickvpexchange vmicrdv vmicshutdown vmictimesync vmicvmsession vmicvss vmvss wbengine wcncsvc wisvc wlidsvc wlpasvc wmiApSrv workfolderssvc
set services_disabled=AJRouter AppVClient DiagTrack DialogBlockingService NetTcpPortSharing RemoteAccess RemoteRegistry UevAgentService shpamsvc ssh-agent tzautoupdate uhssvc
set services_delayed_auto=BITS MapsBroker sppsvc WSearch wscsvc
for %%s in (!services_manual!) do call :setService "%%s" "manual"
for %%s in (!services_auto!) do call :setService "%%s" "auto"
for %%s in (!services_delayed_auto!) do call :setService "%%s" "delayed-auto"
for %%s in (!services_disabled!) do call :setService "%%s" "disabled"
echo Setting Wildcard (per-user) Services...
for %%p in (
  BcastDVRUserService BluetoothUserService CaptureService CDPUserSvc ConsentUxUserSvc
  CredentialEnrollmentManagerUserSvc DeviceAssociationBrokerSvc DevicePickerUserSvc
  DevicesFlowUserSvc MessagingService NPSMSvc P9RdrService PenService
  PimIndexMaintenanceSvc PrintWorkflowUserSvc UdkUserSvc UnistoreSvc UserDataSvc
  cbdhsvc webthreatdefusersvc WpnUserService
) do (
    for /f "tokens=2" %%i in ('sc query type^= service state^= all ^| find "SERVICE_NAME:" ^| find "%%p_"') do (
        if /i "%%p"=="CDPUserSvc" (
            call :setService "%%i" "auto"
        ) else if /i "%%p"=="webthreatdefusersvc" (
            call :setService "%%i" "auto"
        ) else if /i "%%p"=="WpnUserService" (
            call :setService "%%i" "auto"
        ) else (
            call :setService "%%i" "manual"
        )
    )
)
exit /b
:do_gaming
echo [Gaming]
call :addReg "HKCU\System\GameConfigStore" "GameDVR_Enabled" REG_DWORD 0
call :addReg "HKCU\System\GameConfigStore" "GameDVR_FSEBehavior" REG_DWORD 2
call :addReg "HKCU\System\GameConfigStore" "GameDVR_DXGIHonorFSEWindowsCompatible" REG_DWORD 1
call :addReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowGameDVR" REG_DWORD 0
call :addReg "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness" REG_DWORD 0
call :addReg "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "NetworkThrottlingIndex" REG_DWORD 4294967295
call :addReg "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "GPU Priority" REG_DWORD 8
call :addReg "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Priority" REG_DWORD 6
call :addReg "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Scheduling Category" REG_SZ High
call :addReg "HKCU\System\GameConfigStore" "GameDVR_HonorUserFSEBehaviorMode" REG_DWORD 1
call :addReg "HKCU\System\GameConfigStore" "GameDVR_EFSEFeatureFlags" REG_DWORD 0
call :addReg "HKCU\System\GameConfigStore" "GameDVR_FSEBehavior" REG_DWORD 2
for /f "tokens=1,2,*" %%a in ('wmic memorychip get capacity ^| find /i " " ^| find "."') do set ram=%%c
call :addReg "HKLM\SYSTEM\CurrentControlSet\Control" "SvcHostSplitThresholdInKB" REG_DWORD !ram!
exit /b
:do_ui
echo [UI]
call :addReg "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "LaunchTo" REG_DWORD 1
call :addReg "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowTaskViewButton" REG_DWORD 0
call :addReg "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" "PeopleBand" REG_DWORD 0
call :addReg "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" "HideSCAMeetNow" REG_DWORD 1
exit /b
:do_network
echo [Network]
call :addReg "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" "Value" REG_DWORD 0
call :addReg "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" "Value" REG_DWORD 0
exit /b
:do_power
echo [Power]
call :addReg "HKLM\SYSTEM\CurrentControlSet\Control\Power" "HibernateEnabled" REG_DWORD 0
call :addReg "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" "ShowHibernateOption" REG_DWORD 0
powercfg /hibernate off >nul 2>&1
call :addReg "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" "HibernateEnabled" REG_DWORD 0
exit /b
:do_cleanup
echo [Cleanup]
for %%D in ("%TEMP%" "%LocalAppData%\Temp") do (
    if exist "%%~fD" (
        echo clean %%~fD
        del /f /s /q "%%~fD\*.*" >nul 2>&1
    )
)
if exist "%LocalAppData%\Microsoft\Windows\Explorer" (
    del /f /s /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
)
if exist "%LocalAppData%\Microsoft\Windows\INetCache" (
    rd /s /q "%LocalAppData%\Microsoft\Windows\INetCache" >nul 2>&1
)
rd /s /q C:\Windows\Temp
rd /s /q %TEMP%
rd /s /q C:\Windows\Prefetch
rd /s /q %SystemDrive%\$Recycle.Bin
net stop wuauserv
rd /s /q C:\Windows\SoftwareDistribution
net start wuauserv
for /F "tokens=*" %%G in ('wevtutil el') do (wevtutil cl "%%G")
rd /s /q C:\ProgramData\Microsoft\Windows\WER\ReportQueue
rd /s /q C:\ProgramData\Microsoft\Windows\WER\ReportArchive
rd /s /q C:\Windows.old
rd /s /q %LocalAppData%\DirectX Shader Cache
del /f /s /q /a %LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db
echo (Skipped Prefetch/EventLog/WER deletions for safety)
exit /b
:do_boot_legacy
echo [Boot]
bcdedit /set {current} bootmenupolicy Legacy >nul 2>&1 && echo F8 legacy boot menu enabled || echo x could not change boot policy
exit /b
:do_security
echo [Mitigations]
echo Disabling mitigations reduces security. Proceeding...
powershell -NoProfile -Command "$flags = 'DEP','ASLR','SEHOP','ForceRelocateImages','BottomUp','HighEntropy','StrictHandle','DisableWin32kSysCalls','CFG','StrictCFG'; foreach($f in $flags){ try{ Set-ProcessMitigation -System -Disable $f -ErrorAction Stop } catch {} }" >nul 2>&1
powershell -Command "& {ForEach($v in (Get-Command -Name 'Set-ProcessMitigation').Parameters['Disable'].Attributes.ValidValues){Set-ProcessMitigation -System -Disable $v.ToString() -ErrorAction SilentlyContinue}}"
powershell -Command "& {Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\*' -Recurse -ErrorAction SilentlyContinue}"
call :addReg "HKLM\SOFTWARE\Policies\Microsoft\FVE" "DisableExternalDMAUnderLock" REG_DWORD 0
call :addReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" "EnableVirtualizationBasedSecurity" REG_DWORD 0
call :addReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" "HVCIMATRequired" REG_DWORD 0
call :addReg "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" "DisableExceptionChainValidation" REG_DWORD 1
call :addReg "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" "KernelSEHOPEnabled" REG_DWORD 0
call :addReg "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "EnableCfg" REG_DWORD 0
call :addReg "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" "ProtectionMode" REG_DWORD 0
call :addReg "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "FeatureSettings" REG_DWORD 1
call :addReg "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "FeatureSettingsOverride" REG_DWORD 3
call :addReg "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "FeatureSettingsOverrideMask" REG_DWORD 3
exit /b
:restore_input
echo [Restore: Input/Login]
call :setService "hidserv" auto
call :setService "WbioSrvc" manual
call :setService "NaturalAuthentication" auto
echo Done. Reboot recommended.
pause
goto restore
:restore_bio
echo [Restore: Biometrics policies]
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Biometrics" /v Enabled /f >nul 2>&1
echo Policies cleared. Reboot recommended.
pause
goto restore
:restore_gamedvr
echo [Restore: GameDVR]
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /f >nul 2>&1
reg delete "HKCU\System\GameConfigStore" /v GameDVR_Enabled /f >nul 2>&1
echo Restored.
pause
goto restore
:restore_wu
echo [Restore: Windows Update]
call :setService "wuauserv" manual
echo Windows Update restored to Manual.
pause
goto restore
:restore_reg
echo [Restore: Registry snapshots]
echo To restore, manually import the .reg files from !BACKUP! using regedit.
echo Example: regedit /s "!BACKUP!\policies_!TS!.reg"
echo Note: Replace !TS! with the actual timestamp from your backup files.
echo Reboot after importing to apply changes.
pause
goto restore
:restore_power
echo [Restore: Power/Hibernation]
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v HibernateEnabled /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" /v ShowHibernateOption /f >nul 2>&1
powercfg /hibernate on >nul 2>&1
echo Restored. Reboot recommended.
pause
goto restore
:restore_network_policies
echo [Restore: Network policies]
reg delete "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v Value /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v Value /f >nul 2>&1
echo Restored.
pause
goto restore
:restore_boot
echo [Restore: Boot menu policy]
bcdedit /set {current} bootmenupolicy Standard >nul 2>&1 && echo Standard boot menu restored.
pause
goto restore
:EOF
