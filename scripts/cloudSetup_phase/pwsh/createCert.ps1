## This PowerShell script is used to create a certificate for the client in Entra Enterprise Apps for auth purposes (no budget yet for key vault)
## it will also upload the file into the client app (or you can use vs code extension "Azure")

# Prompt the user for a password at runtime
$pwd = Read-Host -Prompt "Enter a password for the certificate" -AsSecureString

# Generate a self-signed certificate
$cert = New-SelfSignedCertificate -Subject "CN=AzureAppCert" -CertStoreLocation "Cert:\CurrentUser\My" -KeyExportPolicy Exportable -KeyLength 2048 -KeyUsage DigitalSignature -NotAfter (Get-Date).AddYears(1)

# Export the certificate as a .pfx file
Export-PfxCertificate -Cert $cert -FilePath "/path/to/AzureAppCert.pfx" -Password $pwd

# Export the certificate as a .cer file (public key only)
Export-Certificate -Cert $cert -FilePath "/path/to/AzureAppCert.cer"

## Uploading the file(s)

az login --use-device-code

# For now, this version; you have to manually copy the app/client id from either a .env file or the myappauth.json file in dataReturns/sensitiveFiles/
az ad app certificate add --id <app-id> \
--file /path/to/AzureAppCert.cer

