# OS Security Labs - Lab 2

## Lab 2: PowerShell Script

### Student: Emre Yeşilkaya

### PowerShell Script: Process Management

Bu lab, kullanıcıların belirli bir parametreye göre süreçleri aramasına, izlemesine ve Windows kayıt defterine betiğin çalışma süresini güncellemesine olanak tanıyan bir PowerShell betiğini içermektedir.

#### Script İçeriği:

```powershell
function Get-ProcessInfo {
    param (
        [string]$searchTerm
    )

    do {
        Write-Host "Getting process list..."
        $processesFound = Get-Process | Where-Object { $_.Name -like "*$searchTerm*" -or $_.Id -eq $searchTerm }

        if ($processesFound -eq $null -or $processesFound.Count -eq 0) {
            Write-Host "No process found matching the search term: $searchTerm"
            $retry = Read-Host "Would you like to try again? (y/n)"
            if ($retry -eq 'y') {
                $searchTerm = Read-Host "Search processes by (name/part of the name/id)"
            }
        } else {
            $processesFound | Format-Table Id, Name -AutoSize
            $processToKill = Read-Host "Do you want to kill a process? Enter the ID (or 'no' to exit)"
            if ($processToKill -ne 'no') {
                try {
                    $process = Get-Process | Where-Object { $_.Id -eq $processToKill }
                    $process.Kill()
                    Write-Host "Process $($process.Name) with ID $processToKill has been killed."
                } catch {
                    Write-Host "Failed to kill the process with ID $processToKill. Error: $_"
                }
            }
            break
        }
    } while ($retry -eq 'y')
}

function Monitor-Processes {
    param (
        [string]$parameter,
        [int]$baseline
    )

    while ($true) {
        try {
            Write-Host "Validating process list..."
            $currentDate = Get-Date -Format "yyyyMMdd_HHmmss"
            $fileName = "FilteredProcessList_$currentDate.csv"
            $processes = Get-Process | Where-Object { ($_.$parameter -gt $baseline) } | Select-Object Name, Id, @{Name="Value"; Expression={$_.$parameter}}

            if ($processes) {
                Write-Host "Writing process list to file: $fileName"
                "Name,Id,Value" | Out-File -FilePath $fileName
                $processes | ForEach-Object {
                    "$($_.Name),$($_.Id),$($_.Value)" | Out-File -FilePath $fileName -Append
                }
            } else {
                Throw "No processes found exceeding the baseline for parameter `$parameter`."
            }
        } catch {
            Write-Host "Error: $_. Exception caught while attempting to monitor processes. Please ensure the parameter name is correct and try again."
            $retry = Read-Host "Would you like to retry with a different parameter or value? (y/n)"
            if ($retry -eq 'y') {
                $parameter = Read-Host "Enter the parameter to monitor (e.g., CPU, VM)"
                $baseline = Read-Host "Enter the baseline parameter value"
                continue
            } else {
                break
            }
        }

        # Housekeeping - Keep only the latest 5 files and then notify
        $files = Get-ChildItem "FilteredProcessList_*.csv" | Sort-Object CreationTime -Descending | Select-Object -Skip 5
        if ($files.Count -gt 0) {
            $files | ForEach-Object { Remove-Item $_.FullName }
            Write-Host "Housekeeping done. Older files have been removed."
        }

        Start-Sleep -Seconds 30
    }
}

function Update-RegistryWithRunTime {
    $path = "HKCU:\Software\PowershellScriptRunTime"
    $keyName = "RunTime"
    $timeStamp = Get-Date -Format "yyyy-MM-dd HH:mm"
    Write-Host "Updating registry with script start time: $timeStamp"

    if (-not (Test-Path $path)) {
        New-Item -Path $path -Force | Out-Null
    }

    Set-ItemProperty -Path $path -Name $keyName -Value $timeStamp
}

# Main script execution starts here
Update-RegistryWithRunTime

$searchBy = Read-Host "Search processes by (name/part of the name/id)"
Get-ProcessInfo -searchTerm $searchBy

try {
    $parameter = Read-Host "Enter the parameter to monitor (e.g., CPU, VM)"
    $baseline = Read-Host "Enter the baseline parameter value"
    Monitor-Processes -parameter $parameter -baseline $baseline
} catch {
    Write-Host "An error occurred: $_"
}
