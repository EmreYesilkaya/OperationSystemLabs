Function Get-SystemInfo {
    $computerName = $env:COMPUTERNAME
    $drives = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } |
              Select-Object DeviceID, 
                            @{Name="Size(GB)";Expression={[math]::Round($_.Size / 1GB, 2)}}, 
                            @{Name="FreeSpace(GB)";Expression={[math]::Round($_.FreeSpace / 1GB, 2)}}
    $cpuUsage = Get-WmiObject -Class Win32_Processor |
                Measure-Object -Property LoadPercentage -Average |
                Select-Object -ExpandProperty Average
    $memory = Get-CimInstance -ClassName Win32_OperatingSystem |
              Select-Object -Property @{Name="TotalPhysicalMemory(MB)";Expression={[math]::Round($_.TotalVisibleMemorySize / 1024, 2)}},
                            @{Name="FreePhysicalMemory(MB)";Expression={[math]::Round($_.FreePhysicalMemory / 1024, 2)}}

    $info = @{
        "ComputerName" = $computerName
        "Drives"       = $drives
        "CPUUsage"     = $cpuUsage
        "Memory"       = $memory
    }

    $filePath = "SystemInfo_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
    $info | Out-File -FilePath $filePath
    Write-Host "System info file saved in: $filePath"
}

Function Write-ServicesToFile {
    $runningServices = Get-Service | Where-Object { $_.Status -eq 'Running' }
    $stoppedServices = Get-Service | Where-Object { $_.Status -eq 'Stopped' }

    $runningFilePath = "RunningServices_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
    $stoppedFilePath = "StoppedServices_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
    
    $runningServices | Out-File -FilePath $runningFilePath
    $stoppedServices | Out-File -FilePath $stoppedFilePath
    
    Write-Host "Running services file saved in: $runningFilePath"
    Write-Host "Stopped services file saved in: $stoppedFilePath"
}

Function Get-ServicesInfo {
    param (
        [Parameter(Mandatory=$true)]
        [string]$serviceName
    )

    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($service) {
        "Service Name: $($service.Name)"
        "Display Name: $($service.DisplayName)"
        "Status: $($service.Status)"
    } else {
        "Service '$serviceName' not found."
    }
}

Function Get-AppEventLogs {
    param (
        [Parameter(Mandatory=$true)]
        [string]$applicationName,

        [Parameter(Mandatory=$true)]
        [int]$count
    )

    $dateString = Get-Date -Format "yyyyMMdd_HHmmss"
    $filePath = "${applicationName}_${dateString}.txt"

    try {
        # Check if the provider exists
        $providerExists = Get-WinEvent -ListProvider $applicationName -ErrorAction SilentlyContinue
        if (-not $providerExists) {
            Write-Host "The specified provider '$applicationName' does not exist or cannot be accessed."
            return
        }

        $events = Get-WinEvent -FilterHashtable @{
            LogName = 'Application';
            ProviderName = $applicationName;
            MaxEvents = $count;
        }

        if ($events) {
            $events | Format-Table -AutoSize | Out-File -FilePath $filePath
            Write-Host "Events for '$applicationName' have been saved to $filePath"
        } else {
            Write-Host "No events found for '$applicationName'."
        }
    } catch {
        Write-Host "An error occurred: $_. Ensure the provider name is correct and that it writes to the 'Application' log, or try a different log name."
    }
}


Function Call-SysInternalApp {
    param (
        [string]$sysInternalAppPath = "C:\Users\emrey\OneDrive\Masaüstü\sysinternal\PsExec.exe"
    )

    $filePath = "SysInternalAppOutput_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
    & $sysInternalAppPath | Out-File -FilePath $filePath
    Write-Host "SysInternal app output saved in: $filePath"
}

Get-SystemInfo
Write-ServicesToFile

# Kullanıcıdan hizmet adı alıp durumunu gösterme
$userServiceName = Read-Host "Please enter the service name you want to check"
Get-ServicesInfo -serviceName $userServiceName

# Bir uygulamanın son olaylarını dosyaya yazma örneği
Get-EventLogs -applicationName "NoteBookFanControlService" -count 10
$Action = New-ScheduledTaskAction -Execute 'Powershell.exe' `
                                  -Argument '-ExecutionPolicy Bypass -File "C:\Users\emrey\OneDrive\Masaüstü\lab3.ps1"'

$Trigger = New-ScheduledTaskTrigger -Daily -At 8am

$Principal = New-ScheduledTaskPrincipal -UserId "DESKTOP-ETCTHST\emrey" 
                                        -LogonType Interactive -RunLevel Highest

Register-ScheduledTask -Action $Action `
                       -Trigger $Trigger `
                       -Principal $Principal `
                       -TaskName "RunLab3Script" `
                       -Description "Executes lab3.ps1 daily at 8:00 AM"

# SysInternal uygulamasını çağırıp çıktısını dosyaya yazma
Call-SysInternalApp -sysInternalAppPath "C:\Users\emrey\OneDrive\Masaüstü\sysinternal\PsExec.exe"