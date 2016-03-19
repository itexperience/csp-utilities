

##################################################
### Скрипт для установки сертификатов с флешки ###
##################################################

# Кодировка
[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("windows-1251")

$fat_array = @()
$reg_array = @()
$token_array = @()
$keys_array = @()

$cpro_sert = &"C:\Program Files\Crypto Pro\CSP\csptest.exe" -keyset -enum_cont -verifycontext -fqcn

foreach($i in $cpro_sert){
#    Write-Host($i)

    if($i –match  "\\\\.\\FAT12"){
        $str = $i.split("\")[-1]
        $fat_array += $str
    }
    if($i –match  "\\\\.\\Aktiv"){
        $str = $i.split("\")[-1]
        $token_array += $str
    }
    if($i –match  "\\\\.\\REGISTRY"){
        $str = $i.split("\")[-1]
        $reg_array += $str
    }  
    if($i –match  "\\\\.\\"){
        $str = $i.split("\")[-1]
        $keys_array += $str
    }
}

$flip = "-"*40

#Write-Host($flip)
#Write-Host("Сертификаты на флешке:")
#foreach($cert in $fat_array){Write-Host($cert)}

#Write-Host($flip)
#Write-Host("Сертификаты на Рутокен:")
#foreach($cert in $token_array){Write-Host($cert)}

#Write-Host($flip)
#Write-Host("Сертификаты в реестре:")
#foreach($cert in $reg_array){Write-Host($cert)}


function CertInstall ($array)
{
    foreach($i in $array){
        &"C:\Program Files\Crypto Pro\CSP\csptest.exe" -property -cinstall -cont $i
        Write-Host("Обработан:" + $i)
    }

} 



while($true){
    Write-Host("Выберите вариант действий:")
    Write-Host("   1 - Установить сертификаты со всех носителей;")
    Write-Host("   2 - Установить сертификаты только с Флешки;")
    Write-Host("   3 - Установить сертификаты только с Рутокена;")
    Write-Host("   4 - Установить сертификаты только из Реестра;")
    Write-Host("   5 - Выход.")
    $choice = Read-host "Выбор"

    if($choice -eq "1"){
        CertInstall ($keys_array)
    }
    if($choice -eq "2"){
        CertInstall ($fat_array)
    }
    if($choice -eq "3"){
        CertInstall ($token_array)
    }
    if($choice -eq "4"){
        CertInstall ($reg_array)
    }
    if($choice -eq "5"){
         Return
    }
}


pause