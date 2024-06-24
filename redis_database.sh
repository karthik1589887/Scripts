#!/bin/bash

# Redis database script to install/start/stop/backup the server

# Only allow Root user to execute the script

if [ "$(whoami)" == 'root' ]; then
    printf "Allowed to execute the script\n"
else
    printf "Access denied, execute as sudo or root user\n"
    exit 1
fi

# Function to install Redis Database

install_redis() {
    printf "Installing Redis Database...\n"
    sudo apt update && sudo apt install -y redis
    if [ $? -eq 0 ]; then
        echo "'''Redis installation completed successfully.'''"
    else
        echo "Redis installation failed."
        exit 1
    fi
    printf "*****************************************\n"
    printf "Your Redis Database current version is: $(redis-cli --version)\n"
    printf "*****************************************\n"
}

# Function to Start the Redis Database

start_redis() {
    sudo systemctl start redis
    if [ $? -eq 0 ]; then
        echo "Redis database started successfully."
    else
        echo "Redis database failed to start."
        exit 1
    fi
    sudo systemctl status redis
}

# Function to Stop the Redis Database

stop_redis() {
    sudo systemctl stop redis
    if [ $? -eq 0 ]; then
        echo "Redis database stopped successfully."
    else
        echo "Redis database failed to stop."
        exit 1
    fi
    sudo systemctl status redis
}

# Function to Backup the Redis Database dump

backup_redis() {
    BACKUP_DIR="/home/vagrant/redis_backup"
    TIMESTAMP=$(date +'%Y%m%d%H%M%S')
    BACKUP_FILE="$BACKUP_DIR/redis_backup_$TIMESTAMP.rdb"

    echo "Backing up Redis data to $BACKUP_FILE..."
    sudo mkdir -p $BACKUP_DIR
    sudo cp /var/lib/redis/dump.rdb $BACKUP_FILE
    if [ $? -eq 0 ]; then
        echo "Redis backup completed successfully."
    else
        echo "Redis backup failed, please check the logs."
        exit 1
    fi
    sudo chown redis:redis $BACKUP_FILE
}

# Display menu options and prompt the user for input

main_manu(){
	while true; do
		echo "Please choose an option:"
		echo "1) Install Redis"
		echo "2) Start Redis"
		echo "3) Stop Redis"
		echo "4) Backup Redis"
		echo "5) Exit"

		read -p "Enter your choice [1-5]: " input

		case $input in
		    1)
		        install_redis
		        ;;
		    2)
		        start_redis
		        ;;
		    3)
		        stop_redis
		        ;;
		    4)
		        backup_redis
		        ;;
		    5)
		        echo "Exiting..."
		        exit 0
		        ;;
		    *)
		        echo "Invalid choice. Please run the script again and choose a valid option."
		        exit 1
		        ;;
		esac
	done

}

# Display the user interactive menu - calling the main menu function

main_manu
