# OS Security Labs - Lab 4

## Lab 4: C# Script

### Student: Emre Yeşilkaya

### C# Script: Process Management

Bu lab, mevcut işlemleri listeleyen, CPU kullanımına göre en üstteki işlemleri dosyaya yazan ve Notepad uygulamasını kapatma seçeneği sunan bir C# betiği içermektedir.

#### Script İçeriği:

```csharp
using System;
using System.Diagnostics;
using System.IO;
using System.Linq;

class Program
{
    static void Main()
    {
        Console.WriteLine("Retrieving the list of processes...");
        WriteProcessesToFile();
        Console.WriteLine("Selecting the top 5 processes by total processor time...");
        WriteTopCpuProcessesToFile();
        Console.WriteLine("Checking for the Notepad application...");
        CheckAndOfferToCloseNotepad();
    }

    static void WriteProcessesToFile()
    {
        using (var writer = new StreamWriter("CurrentProcessList.csv"))
        {
            writer.WriteLine("ProcessId,ProcessName");
            foreach (var process in Process.GetProcesses())
            {
                writer.WriteLine($"{process.Id},{process.ProcessName}");
            }
        }
        Console.WriteLine("CurrentProcessList.csv has been written.");
    }

    static void WriteTopCpuProcessesToFile()
    {
        var topProcesses = Process.GetProcesses().Select(p => new
        {
            Process = p,
            TotalProcessorTime = GetTotalProcessorTimeSafe(p)
        }).OrderByDescending(p => p.TotalProcessorTime).Take(5);

        string dateTime = DateTime.Now.ToString("yyyy-MM-dd_HH-mm");
        using (var writer = new StreamWriter($"TopProcessList_{dateTime}.csv"))
        {
            writer.WriteLine("ProcessId,ProcessName,TotalProcessorTime");
            foreach (var item in topProcesses)
            {
                writer.WriteLine($"{item.Process.Id},{item.Process.ProcessName},{item.TotalProcessorTime}");
            }
        }
        Console.WriteLine($"TopProcessList_{dateTime}.csv has been written.");
    }

    static TimeSpan GetTotalProcessorTimeSafe(Process process)
    {
        try
        {
            return process.TotalProcessorTime;
        }
        catch
        {
            return TimeSpan.Zero;
        }
    }

    static void CheckAndOfferToCloseNotepad()
    {
        var notepadProcess = Process.GetProcessesByName("notepad").FirstOrDefault();
        if (notepadProcess != null)
        {
            Console.WriteLine($"Notepad is running. PID: {notepadProcess.Id}. Do you want to close it? (Y/N)");
            if (Console.ReadLine().Trim().ToUpper() == "Y")
            {
                notepadProcess.Kill();
                Console.WriteLine("Notepad process has been closed.");
            }
        }
        else
        {
            Console.WriteLine("Notepad is not running.");
        }
    }
}
