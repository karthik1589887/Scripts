#!/bin/bash

# Redis database script to install/start/stop/status of the server

# Only allow Root user to execute the script

if [ "$(whoami)" == 'root' ]; then
    printf "Allowed to execute the script \n"
else
    printf "Access denied, execute as sudo or root user \n"
fi

# Function to install Redis Database

function install_redis() {
	printf "Installing Redis Database...\n"
	sudo apt update
	sudo apt install redis
	printf "*****************************************\n"
	printf "Your Redis Database current version is: `redis-cli --version` \n"
	printf "*****************************************\n"
}

# Function to Start the Redis Database

function start_redis() {
	sudo systemctl start redis
    sudo systemctl status redis
}

# Function to Stop the Redis Database

function stop_redis() {
	sudo systemctl stop redis
    sudo systemctl status redis
}

# Function to Backup the Redis Database dump

function backup_redis() {
	BACKUP_DIR="/home/vagrant/redis_backup"
    TIMESTAMP=$(date +'%Y%m%d%H%M%S')
    BACKUP_FILE="$BACKUP_DIR/redis_backup_$TIMESTAMP.rdb"

    echo "Backing up Redis data to $BACKUP_FILE..."
    sudo mkdir -p $BACKUP_DIR
    sudo cp /var/lib/redis/dump.rdb $BACKUP_FILE
    sudo chown redis:redis $BACKUP_FILE
    echo "Redis backup completed."
}

# Display menu options and prompt the user for input

echo "Please choose an option:"
echo "1) Install Redis"
echo "2) Start Redis"
echo "3) Stop Redis"
echo "4) Backup Redis"
echo "5) Exit"

read -p "Enter your choice [1-5]: " input


case $input in
		1 )
		install_redis
		;;
		2 )
		start_redis
		;;
		3 )
		stop_redis
		;;
		4 )
		backup_redis
		;;
		5 )
		echo "Exiting..."
        exit 0
        ;;
		* )
		echo "Invalid choice. Please run the script again and choose a valid option."
        exit 1    
        ;;
esac
