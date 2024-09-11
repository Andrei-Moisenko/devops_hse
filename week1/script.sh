#!/bin/bash

# Function to display help
display_help() {
    echo
    echo "Usage: $0 [option...] {directory} {compression type} {output file name}" >&2
    echo
    echo "   -h, --help          display this help and exit"
    echo "   -b                  backup the specified directory"
    echo
    echo "Example: $0 /home/user/ tar.gz backup.tar.gz"
    echo "Available compression types: tar.gz, tar.bz2, zip"
    echo
    exit 1
}
# Function to log errors with timestamp
log_error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> error.log
}

# Function to backup the directory
backup() {
    # Check if the directory exists
    if [ ! -d "$1" ]; then
        log_error "Error: Directory does not exist" >> error.log
        exit 1
    fi

    # Check if the compression type is valid
    if [ "$2" != "tar.gz" ] && [ "$2" != "tar.bz2" ] && [ "$2" != "zip" ]; then
        log_error "Error: Invalid compression type" >> error.log
        exit 1
    fi

    # Check if the output file name is valid
    if [ -e "$3" ]; then
        log_error "Error: Output file already exists" >> error.log
        exit 1
    fi

    # Suspend all outputs except errors
    exec 3>&1 4>&2 1>/dev/null 2>&1

    # Create the backup archive
    case "$2" in
        tar.gz)
            tar -czf "$3" "$1"
            ;;
        tar.bz2)
            tar -cjf "$3" "$1"
            ;;
        zip)
            zip -r "$3" "$1"
            ;;
    esac

    # Encrypt the backup archive
    gpg -c "$3"

    # Restore outputs
    exec 1>&3 2>&4

    echo "Backup completed successfully"
}

# Main script logic
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    display_help
elif [ "$1" == "-b" ] || [ "$1" == "--backup" ]; then
    if [ $# -ne 4 ]; then
        display_help
    fi
    backup "$2" "$3" "$4"
else
    echo "Invalid option. Use -h or --help for usage information."
    exit 1
fi
