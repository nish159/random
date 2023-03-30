# Run a PowerShell command and capture its output
$output = Get-Process

# Create an empty array to hold the output
$processes = @()

# Loop through the output and add each process to the array
foreach ($process in $output) {
    $processes += [PSCustomObject]@{
        'Name' = $process.ProcessName
        'ID' = $process.Id
        'Memory (MB)' = "{0:N2}" -f ($process.WorkingSet / 1MB)
    }
}

# Export the array to a CSV file
$processes | Export-Csv -Path "C:\output.csv" -NoTypeInformation
