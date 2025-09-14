@echo off
setlocal EnableExtensions EnableDelayedExpansion

chcp 65001 >nul
title Perfect Windows - Safe Configurable Tweaks

for /F "delims=" %%A in ('echo prompt $E^| cmd') do set "ESC=%%A"
set "N=%ESC%[0m"
set "W=%ESC%[97m"
set "K=%ESC%[90m"
set "R=%ESC%[91m"
set "G=%ESC%[92m"
set "Y=%ESC%[93m"
set "B=%ESC%[94m"
set "M=%ESC%[95m"
set "C=%ESC%[96m"

net session >nul 2>&1 || (
    echo %R%Run as Administrator.%N%
    pause
    exit /b
)

set "ROOT=%~dp0"
set "OUT=%ROOT%_perfectwindows"
set "LOG=%OUT%\logs"
set "BACKUP=%OUT%\backups"
set "TS="

for /f "tokens=2 delims==." %%a in ('wmic os get localdatetime /value ^| find "="') do set "TS=%%a"
if not exist "%OUT%" md "%OUT%"
if not exist "%LOG%" md "%LOG%"
if not exist "%BACKUP%" md "%BACKUP%"

set "BUILD="
set "VERSTR="
for /f "tokens=2*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild 2^>nul ^| find "CurrentBuild"') do set "BUILD=%%B"
for /f "tokens=2*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v DisplayVersion 2^>nul ^| find "DisplayVersion"') do set "VERSTR=%%B"
if not defined VERSTR set "VERSTR=(unknown)"
set "OSLINE=Build %BUILD% %VERSTR%"

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
echo   %W%██████╗ ██╗   ██╗  ██╗   ██╗ █████╗  █████╗ ██╗     █████╗ ██╗   ██║%N%
echo   %W%██╔══██╗╚██╗ ██╔╝  ██║   ██║██╔══██╗██╔══██╗██║     ██╔══██╗██║   ██║%N%
echo   %W%██████╦╝ ╚████╔╝   ╚██╗ ██╔╝███████║██║  ╚═╝██║     ███████║╚██╗ ██╔╝%N%
echo   %W%██╔══██╗  ╚██╔╝     ╚████╔╝ ██╔══██║██║  ██╗██║     ██╔══██║ ╚████╔╝ %N%
echo   %W%██████╦╝   ██║       ╚██╔╝  ██║  ██║╚█████╔╝███████╗██║  ██║  ╚██╔╝  %N%
echo   %W%╚═════╝    ╚═╝        ╚═╝   ╚═╝  ╚═╝ ╚════╝ ╚══════╝╚═╝  ╚═╝   ╚═╝   %N%
echo   %K%--------------------------------------------------------------------------------------------------------------%N%
echo   %C%Detected:%N% %W%%OSLINE%%N%     %K%Backups:%N% %W%%BACKUP%%N%
echo.

set /a count=1
call :showToggle PRIVACY         !count! "Privacy / Telemetry hardening"
set /a count+=1
call :showToggle SERVICES        !count! "Service tuning (SAFE profile; keeps HID/Biometrics)"
set /a count+=1
call :showToggle GAMING          !count! "Gaming tweaks (GameDVR off, scheduler, multimedia)"
set /a count+=1
call :showToggle UI              !count! "UI/Taskbar suggestions & ads off"
set /a count+=1
call :showToggle NETWORK         !count! "Network tweaks (Wi-Fi Sense off, feeds off)"
set /a count+=1
call :showToggle POWER           !count! "Power: disable hibernate (saves disk, affects Fast Startup)"
set /a count+=1
call :showToggle CLEANUP         !count! "Cleanup (safe temp/thumbcache only, no Prefetch/log nukes)"
set /a count+=1
call :showToggle SECURITY        !count! "Disable system mitigations (NOT recommended)"
set /a count+=1
call :showToggle BOOT_LEGACY     !count! "Legacy F8 boot menu [advanced]"
set /a count+=1
call :showToggle LOGIN_SAFEGUARD !count! "Login Safeguard (prevents PIN/biometric breakage)"
echo.
echo   %B%[A]%N% Apply    %Y%[P]%N% Preview    %C%[R]%N% Restore    %R%[E]%N% Exit
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
if "!val!"=="1" (echo   !num!. %G%ON %N% — %W%!label!%N%) else (echo   !num!. %R%OFF%N% — %K%!label!%N%)
exit /b

:preview
cls
echo %C%=== DRY RUN / WHAT WILL CHANGE ===%N%
if "%PRIVACY%"=="1" (
    echo %C%[Privacy]%N%
    echo   Disable telemetry and advertising IDs
    if "%LOGIN_SAFEGUARD%"=="0" echo   Disable biometrics and location services
)
if "%SERVICES%"=="1" (
    echo %C%[Services]%N%
    echo   Tune various services to specified start types (e.g., DiagTrack disabled, etc.)
    echo   Handles wildcard services like CDPUserSvc_*
)
if "%GAMING%"=="1" (
    echo %C%[Gaming]%N%
    echo   Disable GameDVR
    echo   Optimize multimedia scheduling for games
)
if "%UI%"=="1" (
    echo %C%[UI]%N%
    echo   Disable taskbar suggestions and ads
)
if "%NETWORK%"=="1" (
    echo %C%[Network]%N%
    echo   Disable Wi-Fi Sense and hotspot reporting
)
if "%POWER%"=="1" (
    echo %C%[Power]%N%
    echo   Disable hibernation
)
if "%CLEANUP%"=="1" (
    echo %C%[Cleanup]%N%
    echo   Clean temp files and thumbnails
)
if "%BOOT_LEGACY%"=="1" (
    echo %C%[Boot]%N%
    echo   Enable legacy F8 boot menu
)
if "%SECURITY%"=="1" (
    echo %C%[Security]%N%
    echo   WARNING: Disable system security mitigations
)
echo.
pause
goto banner

:apply
cls
echo %B%Creating restore point and backups...%N%
powershell -NoProfile -Command "try{Checkpoint-Computer -Description 'PerfectWindows_%TS%' -RestorePointType 'MODIFY_SETTINGS' | Out-Null; Write-Output 'OK'}catch{Write-Output 'SR_failed'}" | findstr /i "OK" >nul || echo %Y%(Restore point could not be created — continue anyway.)%N%

reg export "HKLM\SOFTWARE\Policies" "%BACKUP%\policies_%TS%.reg" /y >nul 2>&1
reg export "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "%BACKUP%\cdm_%TS%.reg" /y >nul 2>&1
reg export "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "%BACKUP%\mmsp_%TS%.reg" /y >nul 2>&1
reg export "HKLM\SYSTEM\CurrentControlSet\Control" "%BACKUP%\control_%TS%.reg" /y >nul 2>&1
sc query type= service state= all > "%BACKUP%\services_%TS%.txt" 2>&1
schtasks /query /v /fo LIST > "%BACKUP%\tasks_%TS%.txt" 2>&1

echo %G%Backups done.%N%
echo.
echo %B%Applying selected tweaks...%N%

if "%PRIVACY%"=="1" call :do_privacy
if "%SERVICES%"=="1" call :do_services
if "%GAMING%"=="1" call :do_gaming
if "%UI%"=="1" call :do_ui
if "%NETWORK%"=="1" call :do_network
if "%POWER%"=="1" call :do_power
if "%CLEANUP%"=="1" call :do_cleanup
if "%BOOT_LEGACY%"=="1" call :do_boot_legacy
if "%SECURITY%"=="1" call :do_security

echo.
echo %G%All selected tweaks applied. A reboot is recommended.%N%
pause
goto banner

:restore
cls
echo %Y%=== RESTORE OPTIONS ===%N%
echo   %B%[1]%N% Re-enable critical input/login services (HID, Biometrics, NaturalAuth)
echo   %B%[2]%N% Restore Windows Hello/Biometrics policies
echo   %B%[3]%N% Re-enable GameDVR
echo   %B%[4]%N% Re-enable Windows Update service
echo   %B%[5]%N% Load full registry snapshot (manual .reg import from %BACKUP%)
echo   %R%[E]%N% Back
choice /c 123456E /n /m "Pick: "
if errorlevel 6 goto banner
if errorlevel 5 goto restore_reg
if errorlevel 4 goto restore_wu
if errorlevel 3 goto restore_gamedvr
if errorlevel 2 goto restore_bio
if errorlevel 1 goto restore_input
goto banner

:setService
if "%~1"=="" exit /b
set "service_pattern=%~1"
set "start_type=%~2"
echo "%service_pattern%" | findstr /c:"*" >nul
if errorlevel 1 (
    call :setSingleService "%service_pattern%" "%start_type%"
) else (
    echo   %Y%Processing wildcard services matching: %service_pattern%%N%
    set "prefix=!service_pattern:~0,-2!"
    set prefix_len=0
    for /L %%i in (0,1,256) do if not "!prefix:~%%i,1!"=="" set /a prefix_len=%%i+1
    set "found=0"
    for /f "delims=" %%s in ('wmic service get name ^| find /v "Name"') do (
        set "svc=%%s"
        if /i "!svc:~0,%prefix_len%!"=="!prefix!" (
            set /a found+=1
            call :setSingleService "!svc!" "%start_type%"
        )
    )
    if "!found!"=="0" echo   %K%- No services found matching "%service_pattern%"%N%
)
exit /b

:setSingleService
set "service_name=%~1"
set "target_type=%~2"
sc qc "%service_name%" >nul 2>&1
if errorlevel 1 (
    echo   %K%- Skip "%service_name%" (does not exist)%N%
    exit /b
)
set "current_start="
for /f "skip=1 delims=" %%m in ('wmic service where name^="%service_name%" get StartMode ^| findstr /r /v "^$"') do if not defined current_start set "current_start=%%m"
if not defined current_start (
    echo   %R%x Failed to get current start type for "%service_name%"%N%
    exit /b
)
set "delayed=0"
if /i "!current_start!"=="Auto" (
    reg query "HKLM\SYSTEM\CurrentControlSet\Services\%service_name%" /v DelayedAutoStart 2>nul | find "0x1" >nul && set "delayed=1"
    if "!delayed!"=="1" set "current_start=delayed-auto"
) else (
    set "current_start=!current_start!"
)
set "skip=0"
if /i "%target_type%"=="!current_start!" set "skip=1"
if "!skip!"=="1" (
    echo   %K%~ "%service_name%" already %target_type%%N%
    exit /b
)
set "sc_type=%target_type%"
if /i "%target_type%"=="delayed-auto" set "sc_type=auto"
if /i "%target_type%"=="manual" set "sc_type=demand"
sc config "%service_name%" start= !sc_type! >nul 2>&1
if errorlevel 1 (
    echo   %R%x Failed to set "%service_name%" start type to !sc_type!%N%
    exit /b
)
if /i "%target_type%"=="delayed-auto" (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\%service_name%" /v DelayedAutoStart /t REG_DWORD /d 1 /f >nul 2>&1
    if errorlevel 1 (
        echo   %R%x Failed to set DelayedAutoStart for "%service_name%"%N%
        exit /b
    )
) else if /i "%target_type%"=="auto" (
    reg delete "HKLM\SYSTEM\CurrentControlSet\Services\%service_name%" /v DelayedAutoStart /f >nul 2>&1
)
echo   %G%* Set "%service_name%" to %target_type% (was !current_start!)%N%
exit /b

:addReg
reg add "%~1" /v "%~2" /t %~3 /d %~4 /f >nul 2>&1 && echo   %G%+ %~1\%~2 = %~4%N% || echo   %R%x %~1\%~2 (failed)%N%
exit /b

:do_privacy
echo %C%[Privacy]%N%
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
if "%LOGIN_SAFEGUARD%"=="0" (
    call :addReg "HKLM\SOFTWARE\Policies\Microsoft\Biometrics" "Enabled" REG_DWORD 0
    call :addReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "DisableLocation" REG_DWORD 1
) else (
    echo   %Y%- Skipped biometrics/location due to LoginSafeguard%N%
)
exit /b

:do_services
echo %C%[Services]%N%

set services_auto=AudioEndpointBuilder Audiosrv BFE BrokerInfrastructure BthAvctpSvc CoreMessagingRegistrar CryptSvc DPS Dhcp Dnscache EventLog EventSystem LanmanServer LanmanWorkstation NaturalAuthentication NgcCtnrSvc NgcSvc NlaSvc ProfSvc Power RpcEptMapper RpcSs SamSs Schedule ShellHWDetection Spooler SysMain Themes UserManager VGAuthService VMTools WinDefend Winmgmt WlanSvc gpsvc iphlpsvc mpssvc nsi
set services_manual=ALG AppIDSvc AppMgmt AppReadiness AppXSvc Appinfo AxInstSV BDESVC BTAGService Browser CDPSvc COMSysApp CertPropSvc ClipSVC CscService DcomLaunch DcpSvc DevQueryBroker DeviceAssociationService DeviceInstall DispBrokerDesktopSvc DisplayEnhancementService DmEnrollmentSvc EFS EapHost EntAppSvc FDResPub Fax FontCache FrameServer FrameServerMonitor GraphicsPerfSvc HomeGroupListener HomeGroupProvider HvHost IEEtwCollectorService IKEEXT InstallService InventorySvc IpxlatCfgSvc KeyIso KtmRm LicenseManager LxpSvc MSDTC MSiSCSI McpManagementService MicrosoftEdgeElevationService MixedRealityOpenXRSvc MsKeyboardFilter NcaSvc NcbService NcdAutoSetup NetSetupSvc Netman Netprofm Netlogon OneSyncSvc_ PNRPAutoReg PNRPsvc PcaSvc PeerDistSvc PerfHost PhoneSvc PlugPlay PolicyAgent PrintNotify PushToInstall QWAVE RasAuto RasMan RetailDemo RmSvc RpcLocator SCPolicySvc SCardSvr SDRSVC SEMgrSvc SNMPTRAP SNMPTrap SSDPSRV ScDeviceEnum SecurityHealthService Sense SensorDataService SensorService SensrSvc SessionEnv SharedAccess SharedRealitySvc SmsRouter SstpSvc StiSvc StorSvc SystemEventsBroker TabletInputService TapiSrv TermService TieringEngineService TimeBroker TimeBrokerSvc TokenBroker TrkWks TroubleshootingSvc TrustedInstaller UI0Detect UmRdpService UsoSvc VSS VacSvc W32Time WEPHOSTSVC WFDSConMgrSvc WMPNetworkSvc WManSvc WPDBusEnum WSService WaaSMedicSvc WalletService WarpJITSvc WbioSrvc Wcmsvc WcsPlugInService WdNisSvc WdiServiceHost WdiSystemHost WebClient Wecsvc WerSvc WiaRpc WinHttpAutoProxySvc WinRM WpcMonSvc WpnService Wudfsvc autotimesvc bthserv camsvc cloudidsvc dcsvc defragsvc diagnosticshub.standardcollector.service diagsvc dmwappushservice dot3svc edgeupdate edgeupdatem fdPHost fhsvc hidserv icssvc lfsvc lltdsvc lmhosts msiserver p2pimsvc p2psvc perceptionsimulation pla seclogon smphost svsvc swprv tiledatamodelsvc upnphost vds vm3dservice vmicguestinterface vmicheartbeat vmickvpexchange vmicrdv vmicshutdown vmictimesync vmicvmsession vmicvss vmvss wbengine wcncsvc wisvc wlidsvc wlpasvc wmiApSrv workfolderssvc
set services_disabled=AJRouter AppVClient DiagTrack DialogBlockingService NetTcpPortSharing RemoteAccess RemoteRegistry UevAgentService shpamsvc spectrum ssh-agent tzautoupdate uhssvc
set services_delayed_auto=BITS MapsBroker sppsvc WSearch wscsvc

echo %W%Adjusting Service Settings...%N%

echo %W%Setting Manual Services:%N%
for %%s in (%services_manual%) do (
    echo %Y%Configuring %%s to start manually...%N%
    sc config "%%s" start= demand >nul 2>&1
    echo Successfully set %%s to Manual
)

echo %W%Setting Automatic Services:%N%
for %%s in (%services_auto%) do (
    echo %B%Configuring %%s to start automatically...%N%
    sc config "%%s" start= auto >nul 2>&1
    echo Successfully set %%s to Automatic
)

echo %W%Setting Delayed Auto Services:%N%
for %%s in (%services_delayed_auto%) do (
    echo %G%Configuring %%s to start automatically with delay...%N%
    sc config "%%s" start= delayed-auto >nul 2>&1
    echo Successfully set %%s to Delayed Auto
)

echo %W%Setting Disabled Services:%N%
for %%s in (%services_disabled%) do (
    echo %R%Disabling %%s...%N%
    sc config "%%s" start= disabled >nul 2>&1
    echo Successfully set %%s to Disabled
)

echo %W%Setting Wildcard Services...%N%
for %%p in (BcastDVRUserService BluetoothUserService CaptureService CDPUserSvc ConsentUxUserSvc CredentialEnrollmentManagerUserSvc DeviceAssociationBrokerSvc DevicePickerUserSvc DevicesFlowUserSvc MessagingService NPSMSvc P9RdrService PenService PimIndexMaintenanceSvc PrintWorkflowUserSvc UdkUserSvc UnistoreSvc UserDataSvc cbdhsvc webthreatdefusersvc WpnUserService) do (
    for /f "tokens=2" %%i in ('sc query type^= service state^= all ^| find "SERVICE_NAME:" ^| find "%%p_"') do (
        if "%%p"=="CDPUserSvc" (
            sc config "%%i" start= auto >nul 2>&1
            echo Configured %%i to auto
        ) else if "%%p"=="webthreatdefusersvc" (
            sc config "%%i" start= auto >nul 2>&1
            echo Configured %%i to auto
        ) else if "%%p"=="WpnUserService" (
            sc config "%%i" start= auto >nul 2>&1
            echo Configured %%i to auto
        ) else (
            sc config "%%i" start= manual >nul 2>&1
            echo Configured %%i to manual
        )
    )
)

echo %W%All service settings have been successfully adjusted.%N%
exit /b

:do_gaming
echo %C%[Gaming]%N%
call :addReg "HKCU\System\GameConfigStore" "GameDVR_Enabled" REG_DWORD 0
call :addReg "HKCU\System\GameConfigStore" "GameDVR_FSEBehavior" REG_DWORD 2
call :addReg "HKCU\System\GameConfigStore" "GameDVR_DXGIHonorFSEWindowsCompatible" REG_DWORD 1
call :addReg "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowGameDVR" REG_DWORD 0
call :addReg "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness" REG_DWORD 0
call :addReg "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "NetworkThrottlingIndex" REG_DWORD 4294967295
call :addReg "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "GPU Priority" REG_DWORD 8
call :addReg "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Priority" REG_DWORD 6
call :addReg "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Scheduling Category" REG_SZ High
exit /b

:do_ui
echo %C%[UI]%N%
call :addReg "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "LaunchTo" REG_DWORD 1
call :addReg "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowTaskViewButton" REG_DWORD 0
call :addReg "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" "PeopleBand" REG_DWORD 0
call :addReg "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "HideSCAMeetNow" REG_DWORD 1
exit /b

:do_network
echo %C%[Network]%N%
call :addReg "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" "Value" REG_DWORD 0
call :addReg "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" "Value" REG_DWORD 0
exit /b

:do_power
echo %C%[Power]%N%
call :addReg "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" "HibernateEnabled" REG_DWORD 0
call :addReg "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" "ShowHibernateOption" REG_DWORD 0
powercfg /hibernate off >nul 2>&1
exit /b

:do_cleanup
echo %C%[Cleanup]%N%
for %%D in ("%TEMP%" "%LocalAppData%\Temp") do (
    if exist "%%~fD" (
        echo   %G%clean %%~fD%N%
        del /f /s /q "%%~fD\*.*" >nul 2>&1
    )
)
if exist "%LocalAppData%\Microsoft\Windows\Explorer" (
    del /f /s /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
)
if exist "%LocalAppData%\Microsoft\Windows\INetCache" (
    rd /s /q "%LocalAppData%\Microsoft\Windows\INetCache" >nul 2>&1
)
echo   %Y%(Skipped Prefetch/EventLog/WER deletions for safety)%N%
exit /b

:do_boot_legacy
echo %C%[Boot]%N%
bcdedit /set {current} bootmenupolicy Legacy >nul 2>&1 && echo   %G%F8 legacy boot menu enabled%N% || echo   %R%x could not change boot policy%N%
exit /b

:do_security
echo %C%[Mitigations]%N%
echo   %R%Disabling mitigations reduces security. Proceeding...%N%
powershell -NoProfile -Command "ForEach($v in (Get-Command -Name 'Set-ProcessMitigation').Parameters['Disable'].Attributes.ValidValues){Set-ProcessMitigation -System -Disable $v.ToString() -ErrorAction SilentlyContinue}" >nul 2>&1
exit /b

:restore_input
echo %C%[Restore: Input/Login]%N%
call :setService "hidserv" auto
call :setService "WbioSrvc" demand
call :setService "NaturalAuthentication" auto
echo   %G%Done. Reboot recommended.%N%
pause
goto restore

:restore_bio
echo %C%[Restore: Biometrics policies]%N%
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Biometrics" /v Enabled /f >nul 2>&1
echo   %G%Policies cleared. Reboot recommended.%N%
pause
goto restore

:restore_gamedvr
echo %C%[Restore: GameDVR]%N%
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /f >nul 2>&1
reg delete "HKCU\System\GameConfigStore" /v GameDVR_Enabled /f >nul 2>&1
echo   %G%Restored.%N%
pause
goto restore

:restore_wu
echo %C%[Restore: Windows Update]%N%
call :setService "wuauserv" demand
echo   %G%Windows Update restored to Manual.%N%
pause
goto restore

:restore_reg
echo %C%[Restore: Registry snapshots]%N%
echo To restore, manually import the .reg files from %BACKUP% using regedit.
echo For example: regedit /s "%BACKUP%\policies_%TS%.reg"
echo Note: Replace %TS% with the actual timestamp from your backup files.
echo Reboot after importing to apply changes.
pause
goto restore
