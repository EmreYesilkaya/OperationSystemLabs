# OS Security Labs

## Lab 1: Sysinternals Tools

### What is Sysinternals
Sysinternals is a collection of free diagnostic and troubleshooting utilities developed by Microsoft for managing, diagnosing, troubleshooting, and monitoring a Microsoft Windows environment. This suite of tools offers advanced functionality beyond the standard tools available in Windows, providing deeper insights and control over various system aspects.

### Process Explorer
Process Explorer is a tool for viewing computer processes. It has two types: UI and command-line. This lab uses the UI version with additional parameters.

#### Parameters:
- `-accepteula`: Automatically accepts the EULA.
- `-alwaysontop`: Keeps Process Explorer always on top.
- `-column <column name>`: Displays the specified column.
- ...

#### Process Information:
Process Explorer shows the following information for each process:
- Process ID (PID)
- Image Name
- Company Name
- ...

### Autoruns
Autoruns is a tool developed by Microsoft that allows you to manage programs and services that start automatically in the Windows operating system.

### Handle
Handle is a command-line tool that displays information about open handles on a Windows system.

#### Commands:
- `-u username`: Displays handles for a specific user.
- `-a`: Displays all handles, including those from kernel-mode drivers.
- ...

### PsKill
PsKill is a command-line tool developed by Microsoft as part of its Sysinternals suite. It allows you to terminate running processes on Windows systems.

#### Advantages:
- Terminating Stubborn Processes
- Remote Termination
- ...

### Process Monitor
Process Monitor is a file system monitor that tracks and records all file and registry access on your Windows system in real-time.

### Zabbix
Zabbix is an OS monitoring tool that monitors various OS functions like CPU, memory, disk usage, network traffic, processes, services, logs, and more.

#### Functionality:
- Monitors various OS functions
- Flexible data collection
- ...

#### User Interface and Ease of Use:
- Modern and user-friendly interface
- Turkish language support
- ...

#### Pros:
- Free and open-source
- Scalable and flexible
- ...

#### Cons:
- Complex initial setup
- Steeper learning curve
- ...
