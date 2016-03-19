
##################################################
### Скрипт для импорта контейнеров из реестра  ###
##################################################

# Кодировка
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("windows-1251")

# Получение имени текущей учетной записи
$User_Name = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
Write-Host("Имя текущего пользователя: " + $User_Name)
$objUser = New-Object System.Security.Principal.NTAccount($User_Name)
# Получение SID текущего пользователя
$user_SID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
Write-Host("SID текущего пользователя: " + $user_SID.Value)


# Получение разрядноси текущего ПК (x86, IA64, AMD64) 
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
$keys_path = $arch_path + "\Crypto Pro\Settings\USERS\" + $user_SID
Write-Host("Путь к ветке реестра: " + $keys_path)


# Путь до рабочего стола
$desktop_path = [Environment]::GetFolderPath("Desktop")
$export_path = $desktop_path + "\ps_keys.reg"
$export_path_out = $desktop_path + "\ps_keys_out.reg"
Write-Host("Файл реестра для импорта: " +$export_path_out)


$test = Get-Content $export_path


$keys_array = @()

foreach($i in $test){
    
    if ($i -match '^\[HKEY'){
        
        $i -replace '(?<=\[).*(?=\\Keys)', $keys_path | Out-File -FilePath $export_path_out -Append -Encoding default
        
        if ($i -match '(?<=Keys\\).*(?=\])'){
            $keys_array += $matches[0]
            }
        }
    else{
        $i | Out-File -FilePath $export_path_out -Append -Encoding default
    }

}

reg import $export_path_out 

#Write-Host($keys_array)

foreach($i in $keys_array){
    #cd  "C:\Program Files\Crypto Pro\CSP\csptest.exe"
    $cont =  "\\.\REGISTRY\" + $i
    &"C:\Program Files\Crypto Pro\CSP\csptest.exe" -property -cinstall -cont $cont

    }

pause