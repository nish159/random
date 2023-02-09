function Get-VMStatus
{
    $vms = Get-Vm -ExcludeState Running, Updating

    # Create an array of objects to store the output of each section
    $output = @()

    Write-Host "`n------------- VM STATES -------------`n"
    $vms | Format-Table Id, Name, Role, State | ForEach-Object {
        $obj = [PSCustomObject]@{
            Id = $_.Id
            Name = $_.Name
            Role = $_.Role
            State = $_.State
        }
        $output += $obj
    }

    Write-Host "`n------------- VM COUNT & JOBS RUNNING ON VMs -------------`n"
    $vms | Group-Object {$_.State} -NoElement | ForEach-Object {
        $obj = [PSCustomObject]@{
            State = $_.Name
            Count = $_.Count
        }
        $output += $obj
    }
    
    $vms | ForEach-Object {
        $vm = $_ 
        Get-Job -ObjectId $vm.Id | Format-Table {$vm.Name}, JobId, State, RetryCount | ForEach-Object {
            $obj = [PSCustomObject]@{
                Name = $_.Name
                JobId = $_.JobId
                State = $_.State
                RetryCount = $_.RetryCount
            }
            $output += $obj
        }
    }

    Write-Host "`n------------- ERRORS ON VMs -------------`n"
    $vms | ForEach-Object {
        $vm = $_
        Get-Job -ObjectId $vm.Id | ForEach-Object {
            $errors = $_
            Get-JobError $errors.JobId -Limit 3 | Format-Table $vm.Name, JobId, Message -Wrap | ForEach-Object {
                $obj = [PSCustomObject]@{
                    Name = $_.Name
                    JobId = $_.JobId
                    Message = $_.Message
                }
                $output += $obj
            }
        }
    }
    
    Write-Host "`n-------------- NON-COMPLETE VM REPLACEMENT RECORD --------------`n"
    $vmReplacements = Get-Vm | Get-VMReplacement -ExcludeState Complete

    $results = @()
    foreach ($vmReplacement in $vmReplacements) {
        $result = [PSCustomObject]@{
            "Id" = $vmReplacement.Id
            "State" = $vmReplacement.State
        }
        $results += $result
    }
    $output += $results

    # Export the array of objects to a CSV file
    $output | Export-Csv -Path "C:\VMStatus.csv" -NoTypeInformation
}

class VMData
{
    [string]$Name
    [string]$Role
    [string]$State
    [string]$JobId
    [string]$RetryCount
    [string]$ErrorMessage
}

function Get-VMStatus
{
    # Using variable to output other data
    $vms = Get-Vm -ExcludeState Running, Updating

    Write-Host "`n------------- VM STATES -------------`n"
    # Get the status of the VMs
    $vms | Format-Table Id, Name, Role, State

    Write-Host "`n------------- VM COUNT & JOBS RUNNING ON VMs -------------`n"
    # Count of the VMs and their state 
    $vms | Group-Object {$_.State} -NoElement
    
    # Store the data in an array of VMData objects
    $vmDataArray = @()
    $vms | ForEach-Object {
        $vm = $_ 
        Get-Job -ObjectId $vm.Id | ForEach-Object {
            $job = $_
            $vmData = [VMData]::new()
            $vmData.Name = $vm.Name
            $vmData.JobId = $job.JobId
            $vmData.RetryCount = $job.RetryCount
            $vmDataArray += $vmData
        }
    }

    Write-Host "`n------------- ERRORS ON VMs -------------`n"
    # Start by getting the jobs running on the VMs 
    # Then pull the last 3 errors on the vm
    $vms | ForEach-Object {
        $vm = $_
        Get-Job -ObjectId $vm.Id | ForEach-Object {
            $errors = $_
            Get-JobError $errors.JobId -Limit 3 | ForEach-Object {
                $error = $_
                $vmData = [VMData]::new()
                $vmData.Name = $vm.Name
                $vmData.JobId = $error.JobId
                $vmData.ErrorMessage = $error.Message
                $vmDataArray += $vmData
            }
        }
    }

    Write-Host "`n-------------- NON-COMPLETE VM REPLACEMENT RECORD --------------`n"
    try
    {
        Get-Vm | Get-VMReplacement -ExcludeState Complete | ForEach-Object {
            $replacement = $_
            $vmData = [VMData]::new()
            $vmData.Name = $replacement.Id
            $vmData.State = $replacement.State
            $vmDataArray += $vmData
        }
    }
    catch
    {
        Write-Host "Exception in  $_"
    }

    # Export the data to a CSV file
    $vmDataArray | Export-Csv -Path "C:\vmData.csv" -NoTypeInformation
}

function Export-VMDataToCSV([VMData[]]$dataArray, [string]$filePath)
{
    $dataArray | Export-Csv -Path $filePath -NoTypeInformation
}
