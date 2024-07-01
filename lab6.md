# OS Security Labs - Lab 6

## Lab 6: Shell Scripts for Record Management

### Student: Emre Yeşilkaya

### Shell Scripts: Record Creation and Management

In this lab, various shell scripts are used for file and directory management. Due to being unable to set up a VM because of a forgotten BIOS password, a server was rented on Google Cloud, and Ubuntu was installed and managed via SSH.

#### Scripts Content:

##### RecordsCreationsScript.sh

```bash
#!/bin/bash

# Creating directories and files
echo "Creating directories and files..."

# Example directory and file creation
mkdir -p /tmp/example_dir
touch /tmp/example_dir/file{1..5}.txt

# Checking the content
echo "Created files:"
ls /tmp/example_dir

echo "Directories and files have been created."

RecordsManagementScript.sh
#!/bin/bash

# Cleaning directories and files
echo "Deleting directories and files..."

# Example directory and file deletion
rm -rf /tmp/example_dir

# Checking the cleanup
if [ ! -d /tmp/example_dir ]; then
  echo "Directory and files successfully deleted."
else
  echo "Failed to delete directory and files."
fi

echo "Cleanup completed."

Setup and Usage:
Save the shell script files to an appropriate directory.
Grant execution permissions to the scripts before running them:
bash

chmod +x RecordsCreationsScript.sh
chmod +x RecordsManagementScript.sh
