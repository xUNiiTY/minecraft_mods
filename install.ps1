Clear-Host

$modsDestination = "$env:USERPROFILE\AppData\Roaming\.minecraft\mods"
$shadersDestination = "$env:USERPROFILE\AppData\Roaming\.minecraft\shaderpacks"
$downloadFolder = "$env:USERPROFILE\Downloads"
$minecraftVersion = "$env:USERPROFILE\AppData\Roaming\.minecraft\versions"
$launcherProfilesJson = "$env:USERPROFILE\AppData\Roaming\.minecraft\launcher_profiles.json"

$fabricInstaller = "https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.1.0/fabric-installer-1.1.0.exe"

$mods = @(
    "https://cdn.modrinth.com/data/P7dR8mSH/versions/UuXf1NbU/fabric-api-0.138.0%2B1.21.10.jar",
    "https://cdn.modrinth.com/data/AANobbMI/versions/VTidoe6U/sodium-fabric-0.7.2%2Bmc1.21.10.jar",
    "https://cdn.modrinth.com/data/YL57xq9U/versions/r1MZ1Bpv/iris-fabric-1.9.6%2Bmc1.21.9.jar",
    "https://cdn.modrinth.com/data/NNAgCjsB/versions/YkqoVa13/entityculling-fabric-1.9.3-mc1.21.10.jar",
    "https://cdn.modrinth.com/data/uXXizFIs/versions/MGoveONm/ferritecore-8.0.2-fabric.jar",
    "https://cdn.modrinth.com/data/mOgUt4GM/versions/e0mxOOIE/modmenu-16.0.0-rc.1.jar",
    "https://cdn.modrinth.com/data/gvQqBUqZ/versions/oGKQMdyZ/lithium-fabric-0.20.0%2Bmc1.21.10.jar",
    "https://cdn.modrinth.com/data/5ZwdcRci/versions/mmM8JfKR/ImmediatelyFast-Fabric-1.13.2%2B1.21.10.jar",
    "https://cdn.modrinth.com/data/EsAfCjCV/versions/8sbiz1lS/appleskin-fabric-mc1.21.9-3.0.7.jar",
    "https://cdn.modrinth.com/data/51shyZVL/versions/nASRyMbu/moreculling-fabric-1.21.9-1.5.0-beta.2.jar",
    "https://cdn.modrinth.com/data/aC3cM3Vq/versions/ULOi34Uh/MouseTweaks-fabric-mc1.21.9-2.29.jar",
    "https://cdn.modrinth.com/data/9s6osm5g/versions/qMxkrrmq/cloth-config-20.0.149-fabric.jar",
    "https://cdn.modrinth.com/data/uCdwusMi/versions/9Y10ZuWP/DistantHorizons-2.3.6-b-1.21.10-fabric-neoforge.jar"

)

$shaders = @(
    "https://cdn.modrinth.com/data/HVnmMxH1/versions/OfRF7dTR/ComplementaryReimagined_r5.6.1.zip",
    "https://cdn.modrinth.com/data/ZvMtQlho/versions/VObMy7ML/Bliss_v2.1.1_%28Chocapic13_Shaders_edit%29.zip",
    "https://cdn.modrinth.com/data/DoODk4HD/versions/z0qQeJe0/I%20Like%20Vanilla%20v1.0.8.zip",
    "https://cdn.modrinth.com/data/LTvf5Tji/versions/JQWprOx9/%C2%A7lLITE%20shaders%204.6.2.zip"
    )
    

    if ((Get-Process | Select-String "Minecraft")) {
        Write-Host "Minecraft (Launcher) muss geschlossen sein!" -ForegroundColor Red
        Return
    }
    
    if (-not (Test-Path $minecraftVersion\1.21.10\)) {
        Write-Host "Minecraft Version 1.21.10 muss installiert sein!" -ForegroundColor Red
        return
    }
    
    if (-not (Test-Path $modsDestination)) {
        New-Item $modsDestination -ItemType Directory
        Write-Host ("[INFO] -", "{0,-60}" -f "shader directory") -NoNewline -ForegroundColor White
        Write-Host "CREATED" -ForegroundColor Green
}

if (-not (Test-Path $shadersDestination)) {
    New-Item $shadersDestination -ItemType Directory
    Write-Host "shader directory created"
}


Write-Host "========== INSTALLING MODS ==========" -ForegroundColor Cyan
foreach ($mod in $mods) {
    $fileName = Split-Path $mod -Leaf
    $literalPath = Join-Path $modsDestination $fileName
    
    
    if (-not (Test-Path $literalPath)) {
        Invoke-WebRequest -Uri $mod -OutFile $literalPath
        Write-Host ("[INFO -]", "{0,-60}" -f $fileName) -NoNewline -ForegroundColor White
        Write-Host "INSTALLED" -ForegroundColor Green
    }
    else {
        Write-Host ("[INFO -]", "{0,-60}" -f $fileName) -NoNewline -ForegroundColor White
        Write-Host "already INSTALLED" -ForegroundColor Yellow
    }
}


Write-Host ""
Write-Host ""


Write-Host "========== INSTALLING SHADERS ==========" -ForegroundColor Cyan
foreach ($shader in $shaders) {
    $fileName = Split-Path $shader -Leaf
    $literalPath = Join-Path $shadersDestination $fileName
    
    if (-not (Test-Path $literalPath)) {
        Invoke-WebRequest -Uri $shader -OutFile $literalPath
        Write-Host ("[INFO] -", "{0,-60}" -f $fileName) -NoNewline -ForegroundColor White
        Write-Host "INSTALLED" -ForegroundColor Green
    }
    else {
        Write-Host ("[INFO] -", "{0,-60}" -f $fileName) -NoNewline -ForegroundColor White
        Write-Host "ALREADY INSTALLED" -ForegroundColor Yellow
    }
}


Write-Host ""
Write-Host ""


Write-Host "========== INSTALLING FABRIC LOADER ==========" -ForegroundColor Cyan
if (-not (Test-Path $downloadFolder\fabric_installer.exe)) {
    Invoke-WebRequest -Uri $fabricInstaller -OutFile $downloadFolder\fabric_installer.exe
    Write-Host ("[INFO] -", "{0,-60}" -f "fabric-installer.exe") -NoNewline -ForegroundColor White
    Write-Host "DOWNLOADED" -ForegroundColor Yellow
}
else {
    Write-Host ("[INFO] -", "{0,-60}" -f "fabric-installer.exe") -NoNewline -ForegroundColor White
    Write-Host "ALREADY DOWNLOADED" -ForegroundColor Yellow
    Write-Host
}


if (-not (Test-Path "$minecraftVersion\fabric-loader-0.17.3-1.21.10")) {
    Start-Process $downloadFolder\fabric_installer.exe -Wait
    Start-Sleep 2
    
    Write-Host ("[INFO] -", "{0,-60}" -f "Fabric Loader") -NoNewline -ForegroundColor White
    Write-Host "INSTALLED" -ForegroundColor Green
}
else {
    Write-Host ("[INFO] -", "{0,-60}" -f "Fabric Loader") -NoNewline -ForegroundColor White
    Write-Host "ALREADY INSTALLED" -ForegroundColor Yellow
}



if (-not (Test-Path (Join-Path $minecraftVersion "..\HTScript.log"))) {
    $json = Get-Content $launcherProfilesJson -Raw | ConvertFrom-Json

    foreach ($profile in $json.profiles.PSObject.Properties) {
        if ($profile.Value.JavaArgs) {
            $profile.Value.JavaArgs = $profile.Value.JavaArgs -replace '-Xmx\d+G', '-Xmx8G'
        }
    }

    $json | ConvertTo-Json -Depth 10 | Set-Content $launcherProfilesJson -Encoding utf8

    Write-Host ("[INFO] -", "{0,-60}" -f "Java Arguments") -NoNewline -ForegroundColor White
    Write-Host "SET TO 8G" -ForegroundColor Green
    "java arguments set" >> (Join-Path $minecraftVersion "..\HTScript.log")
}

else {
    Write-Host ("[INFO] -", "{0,-60}" -f "Java Arguments") -NoNewline -ForegroundColor White
    Write-Host "ALREADY SET" -ForegroundColor Yellow
}


