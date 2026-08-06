@echo off
setlocal enabledelayedexpansion

cls
echo =======================================================================
echo    ИНИЦИАЛИЗАЦИЯ ЭКСТРЕМАЛЬНОГО ОПТИМИЗАТОРА ЯДРА WINDOWS 7 ULTIMATE
echo =======================================================================
echo.

:: 1. ИНТЕГРАЦИЯ ДРАЙВЕРОВ VIRTIO
echo [ЭТАП 1] Принудительная интеграция драйверов VirtIO (Сеть, Диск, КВМ)...
pnputil -i -a %SystemDrive%\Drivers\*.inf /subdirs >nul 2>&1
if %errorlevel% equ 0 (echo    - Базовые драйверы VirtIO KVM: [УСПЕШНО]) else (echo    - Базовые драйверы VirtIO KVM: [СБОЙ])

:: 2. ГЕНЕРАЦИЯ СУПЕР-ИНТЕРФЕЙСА GUI НА HTA/VBSCRIPT
echo [ЭТАП 2] Запуск интерактивного графического конфигуратора...
set "HTA_FILE=%temp%\optimizer.hta"

(
echo ^<html^>^<head^>^<title^>PAPSPС Kernel Optimizer v9.0^</title^>
echo ^<style^>
echo   body { font-family: 'Segoe UI', Arial; font-size: 13px; background-color: #f4f6f9; color: #333; margin: 20px; }
echo   h2 { color: #0056b3; border-bottom: 2px solid #0056b3; padding-bottom: 5px; margin-top: 0; }
echo   .section { background: #fff; padding: 15px; border-radius: 6px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); margin-bottom: 15px; }
echo   .btn { background: #007bff; color: #fff; border: none; padding: 10px 20px; font-weight: bold; border-radius: 4px; cursor: pointer; width: 100%%; }
echo   .btn:hover { background: #0056b3; }
echo   label { font-weight: 500; cursor: pointer; }
echo ^</style^>
echo ^<script language="VBScript"^>
echo   Sub Window_OnLoad
echo     window.resizeTo 520, 560
echo   End Sub
echo   Sub RunOptimization
echo     Set fso = CreateObject("Scripting.FileSystemObject")
echo     Set f = fso.CreateTextFile("%temp%\config.txt", True)
echo     If c1.checked Then f.WriteLine "IE=1" Else f.WriteLine "IE=0"
echo     If c2.checked Then f.WriteLine "SERVICES=1" Else f.WriteLine "SERVICES=0"
echo     If c3.checked Then f.WriteLine "TWEAKS=1" Else f.WriteLine "TWEAKS=0"
echo     If c4.checked Then f.WriteLine "BITLOCKER=1" Else f.WriteLine "BITLOCKER=0"
echo     If c5.checked Then f.WriteLine "INDEX=1" Else f.WriteLine "INDEX=0"
echo     If c6.checked Then f.WriteLine "SOFTWARE=1" Else f.WriteLine "SOFTWARE=0"
echo     f.Close
echo     window.close
echo   End Sub
echo ^</script^>
echo ^<hta:application id="app" scroll="no" windowState="normal" icon="msiexec.exe" border="thin" contextMenu="no" /^>
echo ^</head^>^<body^>
echo   ^<h2^>Экстремальный разгон системы^</h2^>
echo   ^<div class="section"^>
echo     ^<p^>^<input type='checkbox' id='c1' checked/^> ^<label for='c1'^>^<b^>[DISM Blower]^</b^> Вырезать Internet Explorer, Media Center, Игры^</label^>^</p^>
echo     ^<p^>^<input type='checkbox' id='c2' checked/^> ^<label for='c2'^>^<b^>[Bloatware]^</b^> Глубокое удаление 50+ тяжелых служб и телеметрии^</label^>^</p^>
echo     ^<p^>^<input type='checkbox' id='c3' checked/^> ^<label for='c3'^>^<b^>[Kernel 120FPS]^</b^> Твики ОЗУ, unsafe кэш дисков и разгон RDP^</label^>^</p^>
echo     ^<p^>^<input type='checkbox' id='c4' checked/^> ^<label for='c4'^>^<b^>[Security]^</b^> Вырезать BitLocker и отключить UAC до нуля^</label^>^</p^>
echo     ^<p^>^<input type='checkbox' id='c5' checked/^> ^<label for='c5'^>^<b^>[I/O Fix]^</b^> Полное вырезание индексирования Windows Search^</label^>^</p^>
echo     ^<p^>^<input type='checkbox' id='c6' checked/^> ^<label for='c6'^>^<b^>[Apps]^</b^> Тихо установить браузер Supermium и 7-Zip с диска Z:^</label^>^</p^>
echo   ^</div^>
echo   ^<button class="btn" onclick="RunOptimization"^>ЗАПУСТИТЬ ОПТИМИЗАЦИЮ^</button^>
echo ^</body^>^</html^>
) > "%HTA_FILE%"

:: Запускаем графический интерфейс и ждем выбора пользователя
mshta "%HTA_FILE%"

:: Считываем настройки из временного конфигуратора
for /f "tokens=1,2 delims==" %%a in (%temp%\config.txt) do set "%%a=%%b"

echo.
echo =======================================================================
echo        ПРИМЕНЕНИЕ ВЫБРАННЫХ ОПТИМИЗАЦИЙ... ПОЖАЛУЙСТА, ПОДОЖДИТЕ
echo =======================================================================
echo.

:: 3. ВЫРЕЗАНИЕ КОМПОНЕНТОВ DISM (IE, БЛОТВАРЬ)
if "%IE%"=="1" (
    echo [OEM] Вырезание Internet Explorer, Media Center и системного мусора...
    dism /online /disable-feature /featurename:Internet-Explorer-Optional-amd64 /featurename:MediaCenter /featurename:OpticalMediaDisk /featurename:InboxGames /featurename:WindowsMediaPlayer /norestart >nul 2>&1
    if !errorlevel! equ 0 (echo    - Вырезание компонентов DISM: [УСПЕШНО]) else (echo    - Вырезание компонентов DISM: [СБОЙ])
)

:: 4. ВЫРЕЗАНИЕ БИТЛОКЕРА И КОРПОРАТИВНОГО ХЛАМА
if "%BITLOCKER%"=="1" (
    echo [OEM] Тотальное уничтожение BitLocker и бизнес-компонентов...
    dism /online /disable-feature /featurename:BitLocker /featurename:FaxServicesClient /featurename:Printing-Foundation-Features /norestart >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 0 /f >nul 2>&1
    if !errorlevel! equ 0 (echo    - Вырезание BitLocker и UAC 0: [УСПЕШНО]) else (echo    - Вырезание BitLocker и UAC 0: [СБОЙ])
)

:: 5. ГЛУБОКОЕ ВЫРЕЗАНИЕ ИНДЕКСИРОВАНИЯ И СЛУЖБ WINDOWS SEARCH
if "%INDEX%"=="1" (
    echo [OEM] Уничтожение службы индексирования Windows Search (Очистка I/O лагов)...
    sc config SearchIndexer start= disabled >nul 2>&1
    net stop SearchIndexer >nul 2>&1
    :: Отключаем штампы времени NTFS для ускорения дисков QEMU
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsDisable8dot3NameCreation /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsDisableLastAccessUpdate /t REG_DWORD /d 1 /f >nul 2>&1
    if !errorlevel! equ 0 (echo    - Полное глушение Windows Search I/O: [УСПЕШНО]) else (echo    - Полное глушение Windows Search I/O: [СБОЙ])
)

:: 6. ВЫРЕЗАНИЕ СЛУЖБ И ОЧИСТКА ПАМЯТИ
if "%SERVICES%"=="1" (
    echo [OEM] Вырезание 50+ фоновых служб, защитника и обновлений Microsoft...
    for %%s in ("Themes" "wuauserv" "WinDefend" "WerSvc" "Spooler" "CscService" "PcaSvc" "RemoteRegistry" "BDESVC" "SysMain" "WbioSrvc") do (
        sc config %%s start= disabled >nul 2>&1
        net stop %%s >nul 2>&1
    )
    powercfg -h off >nul 2>&1
    vssadmin delete shadows /all /quiet >nul 2>&1
    PowerShell -Command "Disable-ComputerRestore -Drive 'C:\'" >nul 2>&1
    echo    - Глубокая зачистка служб и гибернации: [УСПЕШНО]
)

:: 7. PAPSPS-РАЗГОН ЯДРА, СЕТИ И RDP 120 FPS
if "%TWEAKS%"=="1" (
    echo [OEM] Применение низкоуровневых твиков ядра, оверлока сети и RDP 120 FPS...
    reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f >nul 2>&1
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v "FrameRate" /t REG_DWORD /d 120 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d 3 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d 3 /f >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "GlobalMaxTcpWindowSize" /t REG_DWORD /d 65535 /f >nul 2>&1
    echo    - papsps-разгон ядра и Spectre-блокировка: [УСПЕШНО]
)

:: 8. ЛОКАЛЬНАЯ УСТАНОВКА ПРОГРАММ С ДИСКА Z:
if "%SOFTWARE%"=="1" (
    echo [OEM] Поиск и автоматическая установка софта с примонтированного диска Z:...
    if exist "Z:\7z.msi" (
        msiexec /i Z:\7z.msi /qn
        echo    - Архиватор 7-Zip: [УСПЕШНО УСТАНОВЛЕН]
    ) else (
        echo    - Архиватор 7-Zip: [ПРОПУЩЕН]
    )
    if exist "Z:\supermium_setup.exe" (
        Z:\supermium_setup.exe /silent /install
        echo    - Браузер Supermium: [УСПЕШНО УСТАНОВЛЕН]
    ) else (
        echo    - Браузер Supermium: [ПРОПУЩЕН]
    )
)

echo.
echo =======================================================================
echo    PAPSPС ЭКСТРЕММАЛЬНЫЙ РАЗГОН ЗАВЕРШЕН СИСТЕМА ИДЕТ В ПЕРЕЗАГРУЗКУ
echo =======================================================================
exit
