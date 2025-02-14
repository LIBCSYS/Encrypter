## The Encrypter!
## This script will Encrypt or Decrypt a web.config of your choosing.
## Variables:
# AppName: The name of the application to encrypt or decrypt.
# Encrypt: A switch to encrypt the web.config.
# Decrypt: A switch to decrypt the web.config.
# aspnetRegiis: The path to the aspnet_regiis.exe utility.
# IISRoot: The root path of the application.
# webConfigPath: The path to the web.config file.
# backupPath: The path to the backup web.config file.
# Section: The web.config section to encrypt or decrypt.
# AppPath: The application path for aspnet_regiis.exe.
##
# Use on servers:
# Launch from the c:\scripts\ folder, as it has special properties.
# powershell.exe -noprofile -executionpolicy bypass -file C:\scripts\web.config.encrypt\DevOpsEncrypter.ps1 -AppName "devops" -Encrypt
# powershell.exe -noprofile -executionpolicy bypass -file C:\scripts\web.config.encrypt\DevOpsEncrypter.ps1 -AppName "devops" -Decrypt
# Written for the DevOps Library.
############################################################################################:

param(
    [Parameter(Mandatory = $true)]
    [string]$AppName, # genreally in D:\apps\root, but may change.

    [Parameter(Mandatory = $false)]
    [switch]$Encrypt, # the switch to encrypt the web.config

    [Parameter(Mandatory = $false)]
    [switch]$Decrypt # the switch to decrypt the web.config
    
)

# Function to Encrypt web.config Sections


#
##  START MAIN SECTION
#

# Main Script

############################################################################################:


Write-Output "|-------------------------------------------------------|"
Write-Output "|   Starting web.config operation for app: $AppName     |"
Write-Output "|-------------------------------------------------------|"


# Verify the app path
Write-Output "[ IISRoot is Found as : $IISARoot ]"
$IISRoot = "D:\Apps\Root\$AppName"

if (-not (Test-Path $IISRoot)) {
    Write-Error "The application path '$IISRoot' does not exist. Verify the app name."
    exit 1
}

# Backup web.config
$webConfigPath = Join-Path $IISRoot "web.config"
$backupPath = Join-Path $IISRoot "web.config.bak"

if (Test-Path $webConfigPath) {
    Write-Output "Action:   Backing up web.config to $backupPath..."
    Copy-Item -Path $webConfigPath -Destination $backupPath -Force
    Write-Output "Backup completed."
}
else {
    Write-Error "*** Attention:  Web.config not found in $IISRoot."
    exit 1
}

# Perform Encryption or Decryption
if ($Encrypt) {
    Encrypt-WebConfig -Section "connectionStrings" -AppPath "/$AppName"
}
elseif ($Decrypt) {
    Decrypt-WebConfig -Section "connectionStrings" -AppPath "/$AppName"
}
else {
    Write-Error "Please state weather you want to \n  either -Encrypt or -Decrypt the application."
    exit 1
}

Write-Output "*** DevOps Encrypter execution completed successfully."

##  ##  ##  ##  ##  ##  ##  ##  ##  END MAIN SECTION
#
#  
# Encrypter Function Section.
############################################################################################:
function Encrypt-WebConfig {
    param( [string]$Section, [string]$AppPath )

    $aspnetRegiis = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\aspnet_regiis.exe"
    # you can test to see if aspnet_regiis.exe exists, but since we know it does, I deleted it.

    Write-Output "Encrypting '$Section' section in web.config..."
    & $aspnetRegiis -pe $Section -app $AppPath

    if ($LASTEXITCODE -eq 0) { Write-Output "Encryption successful."  }
    # Don't go here...lol
    else {
        Write-Error "Encryption failed. Check permissions or app path."
        exit 1
    }
} # end Encryption

# Function to Decrypt web.config Sections
function Decrypt-WebConfig {
    param( [string]$Section, [string]$AppPath )

    $aspnetRegiis = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\aspnet_regiis.exe"

    if (-not (Test-Path $aspnetRegiis)) {
        Write-Error "aspnet_regiis.exe not found. Ensure .NET Framework 4.x is installed."
        exit 1
    } # end Decryption

    Write-Output "Decrypting '$Section' section in web.config..."
    & $aspnetRegiis -pd $Section -app $AppPath

    if ($LASTEXITCODE -eq 0) {
        Write-Output "Decryption successful."
    }
    else {
        Write-Error "Decryption failed. Check permissions or app path."
        exit 1
    }
}



# End of the line.
############################################################################################: