# easyMAPT
Powershell script that sets up a virtual android device for mobile penetration testing. Requires Android Studio.

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
```reboot system```
```adb root```
```adb remount```
