##############################################################
######### Скрипт для экспорта контейнеров из реестра #########
#
# 1. Определяет SID текущего пользователя
# 2. Определяет архитектуру ПК
# 3. Эксопртирует ветку с контейнерами в текущую папку скрипта
#
##############################################################

# Кодировка
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("windows-1251")

# Получение имени текущей учетной записи
$User_Name = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

# Получение SID текущего пользователя
$objUser = New-Object System.Security.Principal.NTAccount($User_Name)
$User_SID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])

Write-Host("Имя текущего пользователя: " + $User_Name)
Write-Host("SID текущего пользователя: " + $User_SID.Value)

## Получение разрядноси текущего ПК (x86, IA64, AMD64) 
$os_type = (Get-WmiObject -Class Win32_ComputerSystem).SystemType -match ‘(x64)’
if ($os_type -eq "True") {
    $arch_path = "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node"
    $arch = 64
    #Write-Host($arch_path)
    }
else {
    $os_type = (Get-WmiObject -Class Win32_ComputerSystem).SystemType -match ‘(x86)’
    if ($os_type -eq "True") {
        $arch_path = "HKEY_LOCAL_MACHINE\SOFTWARE"
        $arch = 32
        ##Write-Host($arch_path)
        }
    }

Write-Host("Разрядность ПК: " + $arch)

# Путь к ветке с контейнерами
$keys_path = $arch_path + "\Crypto Pro\Settings\USERS\" + $user_SID + "\Keys"
Write-Host("Путь к ветке реестра: " + $keys_path)
   
# Путь до рабочего стола
$desktop_path = [Environment]::GetFolderPath("Desktop")
$export_path = $desktop_path + "\ps_keys.reg"

# Экспорт файла
reg.exe export $keys_path $export_path "/y"
Write-Host("Файл экспортирован в: " + $export_path)

pause