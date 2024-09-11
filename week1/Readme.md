# Backup Script

This script creates a compressed and encrypted backup of a specified directory.

## Usage


```sh
./script.sh  [option...] {directory} {compression type} {output file name}

Options  
      -h, --help: Display the help message.  
      -b, --backup: Create a backup of the specified directory.  

Example: ./script.sh /home/user/ tar.gz backup.tar.gz

Supported compression types: tar.gz, tar.bz2, zip  
```
