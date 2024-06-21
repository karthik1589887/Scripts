#!/usr/bin/python3

# Redis database script to install/start/stop/status of the server

# Import Modules
#Python code uses the subprocess module to run shell commands

import os
import subprocess
from datetime import datetime

# Only allow Root user to execute the script

if os.geteuid()==0:
	print('Allowed to execute the script')
else:
	print('Access denied, execute as sudo or root user')

# Function to install Redis Database

def install_redis():
    print("Installing Redis Database...")
    
    # Update the package lists
    subprocess.run(["sudo", "apt", "update"], check=True)
    
    # Install Redis
    subprocess.run(["sudo", "apt", "install", "redis"], check=True)
    
    print("*****************************************")
    
# Get the current Redis version

    output = subprocess.run(["redis-cli", "--version"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True, check=True)
    
    print(f"Your Redis Database current version is: {output.stdout.strip()}")
    
    print("*****************************************")

# Function to Stop the Redis database

def stop_redis():
    print("Stopping Redis service...")
    try:
        subprocess.run(["sudo", "systemctl", "stop", "redis"], check=True)
        print("Redis service stopped.")
        
        print("Checking Redis service status after stopping:")
        subprocess.run(["sudo", "systemctl", "status", "redis"], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error stopping or checking Redis service status: {e}")

# Function to start Redis database

def start_redis():
    print("Starting Redis service...")
    subprocess.run(["sudo", "systemctl", "start", "redis"], check=True)
    print("Checking Redis service status after starting:")
    subprocess.run(["sudo", "systemctl", "status", "redis"], check=True)

# Function to Backup the Redis database

def backup_redis():
    BACKUP_DIR = "/home/vagrant/redis_backup"
    TIMESTAMP = datetime.now().strftime('%Y%m%d%H%M%S')
    BACKUP_FILE = f"{BACKUP_DIR}/redis_backup_{TIMESTAMP}.rdb"

    print(f"Backing up Redis data to {BACKUP_FILE}...")

# Create the backup directory if it doesn't exist

    os.makedirs(BACKUP_DIR, exist_ok=True)

    subprocess.run(["sudo", "cp", "/var/lib/redis/dump.rdb", BACKUP_FILE], check=True)
    subprocess.run(["sudo", "chown", "redis:redis", BACKUP_FILE], check=True)
    print("Redis backup completed.")

# User Interactive menu - Main function orchestrates the menu driven interface

def main():
    while True:
        print("\nPlease choose an option:")
        print("1) Install Redis")
        print("2) Start Redis")
        print("3) Stop Redis")
        print("4) Backup Redis")
        print("5) Exit")
        
        try:
            choice = int(input("Enter your choice [1-5]: "))
        except ValueError:
            print("Invalid choice. Please enter a number.")
            continue
        
        if choice == 1:
            install_redis()
        elif choice == 2:
            start_redis()
        elif choice == 3:
            stop_redis()
        elif choice == 4:
            backup_redis()
        elif choice == 5:
            print("Exiting...")
            break
        else:
            print("Invalid choice. Please enter a number between 1 and 5.")

if __name__ == "__main__":
    main()




