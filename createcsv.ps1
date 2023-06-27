# create the name of the columns
$global:handles = "Handles"
$global:NPM = "NPM(K)"
$global:PM = "PM(K)"
$global:WS = "WS(K)"
$global:CPU = "CPU(s)"
$global:ID = "Id"
$global:SI = "SI"
$global:processName = "ProcessName"

function testcsv
{
    # create csv
    $csvPath = ""
    $dateGenerated = (Get-Date -Format "MM_dd_yyyy")
    $file = "test_$dateGenerated.csv"
    $global:path = "$csvPath\$file"

    # add new item
    New-Item $fullPathToCsv -ItemType File
    Set-Content $fullPathToCsv "$handles, $NPM, $PM, $WS, $CPU, $ID, $SI, $processName"
}

function createReport
{
    # call csv function
    testcsv

    # create a variable for the objects
    $process = Get-Process

    # create an array for your objects
    $objects = @()

    # loop through each entry
    foreach($objects in $process)
    {
        # create a new object to write to the csv 
        $object = New-Object psobject
        $object | Add-Member -MemberType NoteProperty $handles -Value $objects.Handles
        $object | Add-Member -MemberType NoteProperty $NPM -Value $objects.NPM
        $object | Add-Member -MemberType NoteProperty $PM -Value $objects.PM
        $object | Add-Member -MemberType NoteProperty $WS -Value $objects.WS
        $object | Add-Member -MemberType NoteProperty $CPU -Value $objects.CPU
        $object | Add-Member -MemberType NoteProperty $ID -Value $objects.Id
        $object | Add-Member -MemberType NoteProperty $SI -Value $objects.SI
        $object | Add-Member -MemberType NoteProperty $processName -Value $objects.ProcessName

        # append objects to the csv file
        $objects | Export-Csv -Path $path -Append -Force -NoTypeInformation
    }
}

# call report function
createReport

=========================================================================================================================================
# Define the CSV file path
$csvPath = "C:\path\to\output.csv"

# Create the CSV header
$header = "Name,Age,City"

# Add the header to the CSV file
$header | Out-File -FilePath $csvPath -Encoding UTF8

# Define the data
$data = @(
    [PSCustomObject]@{
        Name = "John"
        Age = 25
        City = "New York"
    },
    [PSCustomObject]@{
        Name = "Jane"
        Age = 30
        City = "London"
    },
    [PSCustomObject]@{
        Name = "Mike"
        Age = 35
        City = "Sydney"
    }
)

# Append the data to the CSV file
$data | ForEach-Object {
    $line = $_.Name + "," + $_.Age + "," + $_.City
    $line | Out-File -FilePath $csvPath -Append -Encoding UTF8
}

=========================================================================================================================================

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

=========================================================================================================================================
# Parsing Data

# Filtering: Use cmdlets like Where-Object or Select-Object to filter or select specific pieces of information from an output stream.
# For example, you can use Get-ChildItem to list all files in a directory, and then pipe the output to Where-Object to filter by file extension:
Get-ChildItem -Path C:\Data -Recurse | Where-Object {$_.Extension -eq '.txt'}
This will only return files with a .txt extension.

# Splitting: Use methods like Split to split a string into substrings based on a delimiter.
# For example, you can split a string that contains comma-separated values into an array of substrings using the Split method:

$string = 'apple,banana,orange'
$array = $string.Split(',')
# This will create an array with three elements: apple, banana, and orange.

# Regular expressions: Use regular expressions (regex) to match and extract patterns from strings.
# For example, you can use a regex to extract email addresses from a string:

$string = 'john.doe@example.com, jane.doe@example.com'
$regex = '[\w.]+@[\w.]+'
$matches = [regex]::Matches($string, $regex)
foreach ($match in $matches) {
    Write-Output $match.Value
}
# This will output:
# john.doe@example.com
# jane.doe@example.com

# Object manipulation: Use PowerShell's object-oriented features to manipulate and transform objects.
# For example, you can use the ForEach-Object cmdlet to loop through a collection of objects and apply a transformation to each one:
Get-Process | ForEach-Object {
    [PSCustomObject]@{
        'Name' = $_.ProcessName
        'Memory (MB)' = "{0:N2}" -f ($_.WorkingSet / 1MB)
    }
}
# This will create a custom object for each running process, with the process name and memory usage (in megabytes).
