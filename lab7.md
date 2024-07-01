# OS Security Labs - Lab 7

## Lab 7: Bash Script for Process Management

### Student: Emre Yeşilkaya

### Bash Script: Process Management

This lab involves creating a bash script to manage processes by name and PID, as well as filtering process lists. The script was tested on an Ubuntu server on Google Cloud due to issues with the local setup.

#### Scripts Content:

##### ProcessManagementScript.sh

```bash
#!/bin/bash

# Function to kill a process by name
kill_process_by_name() {
    local process_name=$1
    pkill -f "$process_name"
    if [ $? -eq 0 ]; then
        echo "Process $process_name killed successfully."
    else
        echo "No process found with name $process_name."
    fi
}

# Function to kill a process by PID
kill_process_by_pid() {
    local pid=$1
    kill -9 "$pid"
    if [ $? -eq 0 ]; then
        echo "Process with PID $pid killed successfully."
    else
        echo "No process found with PID $pid."
    fi
}

# Function to filter process list and save to a file
filter_process_list() {
    ps aux | grep -v grep | grep "$1" > FilteredProcessList.txt
    nano FilteredProcessList.txt
}

# Main script
echo "Process Management Script"
echo "1. Kill process by name"
echo "2. Kill process by PID"
echo "3. Filter process list"

read -p "Choose an option: " option

case $option in
    1)
        read -p "Enter the process name to kill: " process_name
        kill_process_by_name "$process_name"
        ;;
    2)
        read -p "Enter the PID to kill: " pid
        kill_process_by_pid "$pid"
        ;;
    3)
        read -p "Enter the process name to filter: " process_name
        filter_process_list "$process_name"
        ;;
    *)
        echo "Invalid option."
        ;;
esac


Setup and Usage:
Save the bash script to an appropriate directory as ProcessManagementScript.sh.
Grant execution permission to the script:
bash

chmod +x ProcessManagementScript.sh


Run the script:
bash

./ProcessManagementScript.sh
