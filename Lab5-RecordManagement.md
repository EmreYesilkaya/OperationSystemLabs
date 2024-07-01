# OS Security Labs - Lab 5

## Lab 5: C# Console Application for System Information

### Student: Emre Yeşilkaya

### C# Console Application: System and Event Log Information

This lab includes a C# console application that collects system information and displays event logs for a specific application.

#### Script İçeriği:

```csharp
using System;
using System.Diagnostics;
using System.Management;
using System.Linq;
using System.Threading;

namespace SystemInfoLib
{
    public class SystemInformation
    {
        public void GetSystemDetails()
        {
            Console.WriteLine("Sistem bilgileri alınıyor...");

            // Bilgisayar Adı
            string computerName = Environment.MachineName;
            Console.WriteLine($"Bilgisayar Adı: {computerName}");

            // Sabit Disk Bilgileri
            using (var searcher = new ManagementObjectSearcher("SELECT * FROM Win32_DiskDrive"))
            {
                foreach (ManagementObject wmi_HD in searcher.Get())
                {
                    Console.WriteLine($"Disk Modeli: {wmi_HD["Model"]}");
                    Console.WriteLine($"Disk Kapasitesi: {wmi_HD["Size"]} bytes");
                }
            }

            // CPU Kullanımı
            using (var cpuCounter = new PerformanceCounter("Processor", "% Processor Time", "_Total"))
            {
                cpuCounter.NextValue(); // İlk değeri atla
                Thread.Sleep(1000); // Performans sayacının bir sonraki değeri için bir saniye bekle
                Console.WriteLine($"CPU Kullanımı: {cpuCounter.NextValue():0.00}%");
            }

            // Fiziksel Bellek Bilgileri
            using (var ramCounter = new PerformanceCounter("Memory", "Available MBytes"))
            {
                Console.WriteLine($"Boş Fiziksel Bellek: {ramCounter.NextValue()} MB");
            }
        }

        public void GetApplicationEvents(string application)
        {
            Console.WriteLine($"{application} uygulamasına ait olaylar alınıyor...");

            using (EventLog appLog = new EventLog(application))
            {
                var entries = appLog.Entries.Cast<EventLogEntry>()
                                .OrderByDescending(x => x.TimeGenerated)
                                .Take(10);

                foreach (var entry in entries)
                {
                    Console.WriteLine($"Zaman: {entry.TimeGenerated} - Mesaj: {entry.Message}");
                }
            }
        }
    }
}

using System;
using SystemInfoLib; // Eğer sınıfınızı bir namespace altında tanımladıysanız

class Program
{
    static void Main(string[] args)
    {
        var sysInfo = new SystemInformation();
        sysInfo.GetSystemDetails();
        sysInfo.GetApplicationEvents("System"); // "System" kaynağından olayları al
    }
}

Add-Type -Path "C:\path\to\SystemInfoLib.dll"

# SystemInformation sınıfından bir nesne oluştur
$systemInfo = New-Object SystemInfoLib.SystemInformation

$systemInfo.GetSystemDetails()
$systemInfo.GetApplicationEvents("System")
