# Define the desired length (16 characters, a multiple of 4)
$length = 16

# Generate random bytes
$randomBytes = New-Object byte[] $length
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($randomBytes)

# Encode the random bytes in base64
$base64Password = [Convert]::ToBase64String($randomBytes)

Write-Host "Generated Base64 Password: $base64Password"
