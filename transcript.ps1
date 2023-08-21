# Set the path where transcripts will be saved
$transcriptPath = "C:\Path\To\Transcripts"

# Create the directory if it doesn't exist
if (-not (Test-Path -Path $transcriptPath)) {
    New-Item -Path $transcriptPath -ItemType Directory
}

# Get the current date in the format "YYYY-MM-DD"
$currentDate = Get-Date -Format "yyyy-MM-dd"

# Create the transcript file name
$transcriptFileName = "Transcript_$currentDate.txt"
$transcriptFilePath = Join-Path -Path $transcriptPath -ChildPath $transcriptFileName

# Start transcript recording
Start-Transcript -Path $transcriptFilePath -force

# Run your desired commands here

# Stop transcript recording
Stop-Transcript

# The path to the existing file
$filePath = "C:\Path\To\Your\File.txt"

# The text you want to append
$textToAppend = "This is the text you want to append."

# Append text to the file
$textToAppend | Out-File -FilePath $filePath -Append

