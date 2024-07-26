Set-ExecutionPolicy Bypass
$cacert        = "C:\path\to\cert" # Location of your .der cert
$avd           = "AVD_Name"      # AVD Name
$Burp          = "10.10.10.10:8080"  # Burp Address, likely on local network or local hos
$condition     = $true                 # Condition for loops
$checkInterval = 5                     # How many seconds to recheck device
$qProcess      = "qemu-system-x86_64"  # Qemu process that starts, change if system non 64-bit

Write-Host "[*] Starting Emulator with -writable-system flag"


Start-Process -FilePath emulator.exe -ArgumentList "-avd $avd -writable-system"


# Wait for android to boot
$c = 0 # Counter for qemu message
while ($condition) {
    
    if (Get-Process -Name qemu-system-x86_64 -ErrorAction SilentlyContinue) {
        
        if ($c -eq 0){
            Write-Host "[+] $qProcess started"
        }
        $c = 1

        $device_status =  adb shell getprop init.svc.bootanim
        if ($device_status -eq "stopped") {
            Write-Host "[+] $avd accessible"
            $condition = $false
        }
        else {
        Write-Host "[-] $avd not accessible. Checking again in $checkInterval seconds..."
        }

    } else {
        Write-Host "[-] $qProcess not started. Checking again in $checkInterval seconds..."
    }
    Start-Sleep -Seconds $checkInterval
}
$condition = $true # reset check

Write-Host "[*] Rooting"
adb root
Start-Sleep -Seconds 5

Write-Host "[*] Disabling Verification"
adb shell avbctl disable-verification
Start-Sleep -Seconds 5

Write-Host "[*] Rebooting"
adb reboot

$device_status =  adb shell getprop init.svc.bootanim
# Wait for android to boot
while ($condition) {
    $device_status =  adb shell getprop init.svc.bootanim
    if ($device_status -eq "stopped") {
        Write-Host "[+] $avd accessible"
        $condition = $false
    } else {
        Write-Host "[-] $avd not accessible. Checking again in $checkInterval seconds..."
    }
    Start-Sleep -Seconds $checkInterval
}


Write-Host "[*] Rooting"
adb root
Start-Sleep -Seconds 5

Write-Host "[*] Remounting"
adb remount
Start-Sleep -Seconds 5

Write-Host "[*] Pushing " $cacert " to /system/etc/security/cacerts/"  
adb push $cacert /system/etc/security/cacerts/
Start-Sleep -Seconds 5

Write-Host "[*] Setting Proxy " $Burp
adb shell settings put global http_proxy $Burp
Start-Sleep -Seconds 5

Write-Host "[*] Remounting"
adb remount
Start-Sleep -Seconds 5

Write-Host "[+] easyMAPT Complete - Shell Accessible Below:"

adb shell