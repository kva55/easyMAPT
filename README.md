# easyMAPT
Powershell script that sets up a virtual android device for mobile penetration testing. 
Requires Android Studio and Burp Suite Proxy.

## Important Information
- If you're getting the error "adbd cannot run as root in production builds", this is because this tool only works on non-live ISO images (Default Android System Image).
- Have these environment variables in the users path or hardcode them:
  - platform-tools
  - Android/Sdk/emulator
 
## Troubleshooting
- Load multiple AVDs with varying API versions, applications can sometimes react differently
- Device may needs to have the ca re-added after reboot, the re-mount isn't always persistent

# Burp Certificate
For this script, it is assumed that the burp suite certficate name is the subject hash.
Portable openssl can be used, but for this example linux subsystem (wsl) was used. Wsl is not used within the script itself

```wsl --update```

```wsl --install -d Debian```

```openssl x509 -inform DER -subject_hash_old -in cert.der```

```cp cert.der 9aabbcce.0```


# Tasks performed
```emulator.exe -list-avds```

```emulator.exe -avd <avd-name> -writable-system```

```adb root```

```adb shell avbctl disable-verification``` <- Newer APIs may not require this, and may not recognize it

```adb reboot```

```adb root```

```adb remount```

```adb push "your\path\to\9aabbcce.0" /system/etc/security/cacerts/```

```adb shell settings put global http_proxy 10.10.10.10:8080``` <- your proxy ip:port

```adb remount```

```adb shell``` <- your device should be rooted, and sending communications to Burp Suite

# Setting up AVD:

As shown in the screenshots below, make sure not to use a live image otherwise rooting the device will not work. 
<div align="center">
  <img src="https://github.com/user-attachments/assets/f0b72698-4d0b-47be-8a0c-2f0c4df16e4d" style="width: 90%;">
  <img src="https://github.com/user-attachments/assets/1ad9ed42-1a1a-4ceb-9716-13de75c674ea" style="width: 90%;">
</div>

# Running the PowerShell Script:

## Change these variables:
<pre>
$cacert        = "C:\Users\username\Desktop\Burp-Cert\9aabbcce.0" # Location of your .der cert
$avd           = "AVD_Name"            # AVD Name
$Burp          = "10.10.10.10:8080"    # Burp Address, likely on local network or local hos
$checkInterval = 5                     # How many seconds to recheck device
$qProcess      = "qemu-system-x86_64"  # Qemu process that starts, change if system non 64-bit
</pre>

1. Open PS as administrator
2. ``Set-Execution Policy Bypass``
3. ``.\easyMAPT.ps1``

<div align="center">
  <img src="https://github.com/user-attachments/assets/384a557e-67a5-4031-915c-38f984290a04" style="width: 90%;">
  <img src="https://github.com/user-attachments/assets/27d40f8c-5206-453d-8a56-5bf626b1f736" style="width: 90%;">
</div>


