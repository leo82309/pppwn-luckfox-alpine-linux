#!/bin/sh
echo "______________________________                       "
echo "\\______   \\______   \\______   \\__  _  ______  "
echo " |     ___/|     ___/|     ___/\\ \\/ \\/ /    \\ "
echo " |    |    |    |    |    |     \\     /   |  \\     "
echo " |____|    |____|    |____|      \\/\\_/|___|  /    "
echo "                                           \\/       "
echo " __                 __      _____                    " 
echo "|  |  __ __   ____ |  | ___/ ____\\_______  ___      "
echo "|  | |  |  \\_/ ___\\|  |/ /\\   __\\/  _ \\  \\/  / "
echo "|  |_|  |  /\\  \\___|    <  |  | (  <_> >    <      "
echo "|____/____/  \\_____>__|_ \\ |__|  \\____/__/\\_ \\  "
echo ""
echo "by: https://github.com/0x1iii1ii/PPPwn-Luckfox"
echo ""
echo "credit to:"
echo "https://github.com/TheOfficialFloW/PPPwn"
echo "https://github.com/xfangfang/PPPwn_cpp"
echo ""
echo "Modded by Reo_Auin for Alpine Linux"
# Display the list of firmware versions
echo "Please select your PS4 firmware version:"
echo "a) 900 / 960 / 1000 / 1001 / 1100"
# Prompt the user for the selection
read -p "Enter your firmware: " FW_VERSION
# Set the firmware version based on the user's choice
# Confirm the firmware version selection
echo "You have selected firmware version $FW_VERSION. Is this correct? (y/n)"
read -p "Enter your choice: " CONFIRMATION
if [[ $CONFIRMATION != "y" ]]; then
    echo "Firmware selection not confirmed. Exiting."
    exit 1
fi
# Define the paths for the stage1 and stage2 files based on the firmware version
STAGE1_FILE="stage1/$FW_VERSION/stage1.bin"
STAGE2_FILE="stage2/$FW_VERSION/stage2.bin"
# Create the execution script with the user inputs
cat <<EOL > /root/pppwn_script.sh
#!/bin/sh
# Define variables
FW_VERSION=$FW_VERSION
STAGE1_FILE="$STAGE1_FILE"
STAGE2_FILE="$STAGE2_FILE"
# fix sshd
rm -rf /var/empty
rc-service sshd restart
# Disable eth0
ifconfig eth0 down
# Wait a second
sleep 1
# Enable eth0
ifconfig eth0 up
# Wait a second
sleep 1
# Execute the pppwn command with the desired options
./root/pppwn --interface eth0 --fw $FW_VERSION --stage1 "/root/$STAGE1_FILE" --stage2 "/root/$STAGE2_FILE" -a -t 5 -nw -wap 2
# Check if the pppwn command was successful
if [ \$? -eq 0 ]; then
    echo "pppwn execution completed successfully."
    sleep 10
    ifconfig eth0 down
	sleep 5
	exit
else
    echo "pppwn execution failed. Exiting script."
    exit 1
fi
EOL
# Make the pppwn and script executable
chmod +x /root/pppwn_script.sh
chmod +x /root/pppwn
# Create the pppwnservice file
cat <<EOL > /etc/init.d/pppwnservice
#!/sbin/openrc-run
name="pppwn-service"
description="PPPwn Service Script"
command="/root/pppwn_script.sh"
command_background=true
pidfile="/run/${RC_SVCNAME}.pid"
EOL
# Move and enable the service file
chmod 755 /etc/init.d/pppwnservice
cd /etc/init.d
rc-update add pppwnservice default
echo "install completed! rebooting..."
reboot
