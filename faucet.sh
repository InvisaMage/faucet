#!/bin/bash
# Faucet - Easily manage a Waterfall server
# Tested on Debian/Ubuntu systems and WSL: https://docs.microsoft.com/en-us/windows/wsl/install-win10
# Dependencies - jq (https://stedolan.github.io/jq/), curl, and Java
# Created by Travis Kipp

# README: If you don't know what this is, you probably shouldn't be here. Edit the faucet.conf file only
# TODO: 

#Colors
RESET='\e[0m'
GREEN='\e[92m'
RED='\e[91m'
BBLUE='\e[0;34m\e[1m'
BWHITE='\e[97m'
YELLOW='\e[93m'
TAG="${BBLUE}[Faucet]${RESET} "
VER="v0.0.2-alpha"

echo -e ${BBLUE} "  ______                   _   ";
echo -e ${BBLUE} " |  ____|                 | |  ";
echo -e ${BBLUE} " | |__ __ _ _   _  ___ ___| |_ ";
echo -e ${BBLUE} " |  __/ _\` | | | |/ __/ _ \ __|";
echo -e ${BBLUE} " | | | (_| | |_| | (_|  __/ |_ ";
echo -e ${BBLUE} " |_|  \__,_|\__,_|\___\___|\__|";
echo -e ${BBLUE} "                               ";
echo -e ${BBLUE} "                               ";
echo -e "${BWHITE}                  Version: ${YELLOW}${VER}";
echo -e "${BWHITE}                Created by: ${GREEN}Travis Kipp";
echo -e "";

#Create config file if it doesn't exist
createConfig() {
cat >> faucet.conf <<'EOL'
# Faucet - Easily manage a Waterfall server
# Config Version: v0.0.2-alpha
# Tested on Debian/Ubuntu systems and WSL: https://docs.microsoft.com/en-us/windows/wsl/install-win10
# View the requirements in the README.md file
# Customize this to your liking

#General
#Faucet Version
#Avialable versions: https://papermc.io/api/v2/projects/waterfall
#!!!Ensure the version actually exists!!!
#When changing major and minor versions, delete .ft_current_build.txt
version="1.17"
debug=false #Prevents starting the server

#Features
doBackup=true #Copies the entire server directory to another location; runs based on settings below
trimBackups=false #Delete old backups based on trimDays

#Backup Settings
backupDir="/tmp/${server_name}-backups/" #Recommend changing this to another disk
backupDate=$(date +%Y-%m-%d)
currentDate=$(date +%s)
trimDays=28
day=86400
EOL
}

#Create config file
#If faucet.conf does not exists, write to file
if [ -f faucet.conf ] ; then
    echo -e  "${TAG}Config file found, reading..."
	echo -e  ""
	#Overwrite default settings from faucet.conf
	source faucet.conf
else
    echo -e  "${TAG}${RED}faucet.conf not found${RESET}, creating file and writting defaults"
	createConfig
fi

#Functions

#exit 1
exitScript() {
	echo -e  "${TAG}${RED}Exiting...${RESET}"
	exit 1
}

#Backup
backup() {
    #Create folder
	echo -e  "${TAG}Backing up server..."
    echo -e  "${TAG}Creating ${backupDir}${server_name} ${backupDate}"
	
	#Exit if cannot create backup dir (If previous command failed - exit)
	if mkdir -p "${backupDir}${server_name} ${backupDate}" ; then
		echo -e "${TAG}${GREEN}Created ${backupDir}${server_name} ${backupDate}"
	else
		echo -e "${TAG}${RED}Failed to create ${backupDir}${server_name} ${backupDate}"
		exitScript
	fi


    #Copy all files recursively in current dirrectory while retaining file atrributes
    echo -e  "${TAG}Copying files into ${backupDir}${server_name} ${backupDate}"
	
	if cp -ar * "${backupDir}${server_name} ${backupDate}" ; then
		echo -e  "${TAG}${GREEN}Backup completed"
		echo -e  $currentDate > .ft_last_backup.txt
	else
		echo -e "${TAG}${RED}Failed to create ${backupDir}${server_name} ${backupDate}"
		exitScript
	fi
}

#Trim
trim() {
    echo -e  "${TAG}${YELLOW}Trimming backups older than ${trimDays} days..."
    find "$backupDir" -mindepth 1 -maxdepth 1 -type d -mtime +${trimDays} -exec rm -rf {} +
    echo -e  "${TAG}${GREEN}Done"
}

#Online check
onlineCheck() {
    wget -q --spider https://papermc.io

    if [ $? -eq 0 ]; then
        echo -e  "${TAG}${GREEN}Waterfall online"
    else
        echo -e  "${TAG}${RED}Unable to connect to Waterfall"
		printf "${TAG}${YELLOW}Start server [Y/n]? ${RESET}"
		read -r answer
		if [ "$answer" = "" ] || [ "$answer" = "Y" ] || [ "$answer" = "y" ] ; then
		   startLoop
		else
		   exitScript
	    fi
    fi
}

#Start server jar and restart if crashes
#https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft/
startLoop() {
    if [ "$debug" = true ] ; then
	    echo -e  "${TAG}${YELLOW}Debugging mode enabled..."
		exitScript
	else
	    echo -e  "${TAG}Starting server..."
        while true; do
		    java -Xms512M -Xmx512M -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -jar waterfall.jar
            echo -e  "${TAG}Restart in ${GREEN}5 seconds. ${BWHITE}Ctrl + C to stop."
            sleep 5
	    done
    fi
}

#Get latest build from Waterfall API
buildDownload() {
    curl -o waterfall.jar "https://papermc.io/api/v2/projects/waterfall/versions/${version}/builds/${latest_build}/downloads/waterfall-${version}-${latest_build}.jar"
	echo -e  $latest_build > .ft_current_build.txt
	echo -e  "${TAG}Downloaded latest Waterfall build"
}

#Start
#Check if jq is installed
if type jq &>/dev/null ; then
    echo -e "${TAG}${RESET}jq is installed"
else
    echo -e "${TAG}${RED}jq is not installed"
	exitScript
fi

#Check if Java is installed
if which java &>/dev/null ; then
    echo -e "${TAG}${RESET}Java is installed"
else
    echo -e "${TAG}${RED}Java is not installed"
	exitScript
fi

#Check if Curl is installed
if which curl &>/dev/null ; then
    echo -e "${TAG}${RESET}Curl is installed"
else
    echo -e "${TAG}${RED}Curl is not installed"
	exitScript
fi

echo -e ""

#If last backup date file exists, continue, if not create file
if [ "$doBackup" = true ] ; then
    if [ -f .ft_last_backup.txt ] ; then
		last_backup_date=$(cat .ft_last_backup.txt)
	else
		echo -e  "${TAG}${RED}pt_backup_date.txt not found, ${RESET}creating file"
		echo -e  "0" > .ft_last_backup.txt
		last_backup_date=$(cat .ft_last_backup.txt)
		backup
	fi

	#If last backup date is older than 1 day, backup server
	if [ $currentDate -gt $(($last_backup_date+$day)) ]; then
		echo -e  "${TAG}${YELLOW}Backup is older than ${day} seconds"
		backup
	else
		echo -e  "${TAG}${YELLOW}Backup is current"
	fi
fi


#trim
if [ "$trimBackups" = true ] ; then
    trim
fi
onlineCheck

#If current build file exists, continue, if not create file
if [ -f .ft_current_build.txt ] ; then
    current_build=$(cat .ft_current_build.txt)
else
    echo -e  "${TAG}${RED}ft_current_build.txt not found, ${RESET}creating file"
	echo -e  "0" > .ft_current_build.txt
	current_build=$(cat .ft_current_build.txt)
fi

#Get latest build information from Waterfall API
latest_build=$(curl -s https://papermc.io/api/v2/projects/waterfall/versions/${version} | jq -r '.builds[-1]')
echo -e  "${TAG}Got latest build info for Waterfall"

#If current build is older than latest build, download latest build and save to file
if [[ $current_build < $latest_build ]]; then
    echo -e  "${TAG}Downloading latest Waterfall build..."
	buildDownload
	echo -e  "${TAG}${GREEN}Waterfall update completed"
	startLoop
else
    echo -e  "${TAG}${GREEN}Waterfall is already up to date"
	startLoop
fi