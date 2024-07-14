#!/bin/sh
echo "Made by Reo_Auin for Luckfox Pico Alpine Linux Docker"
sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
apk update
apk add openrc
apk add openssh
rc-update add devfs boot
rc-update add procfs boot
rc-update add sysfs boot
rc-update add sshd default
echo ttyFIQ0 > /etc/securetty
cat <<EOL > /etc/inittab
::sysinit:/sbin/openrc sysinit
::sysinit:/sbin/openrc boot
::wait:/sbin/openrc default

# Set up a couple of getty's Delete the lines below this

# Put a agetty on the serial port Modify the line below like this, others unchanged
ttyFIQ0::respawn:/sbin/agetty --autologin root ttyFIQ0 vt100

# Stuff to do for the 3-finger salute
::ctrlaltdel:/sbin/reboot

# Stuff to do before rebooting
::shutdown:/sbin/openrc shutdown
EOL
cat <<EOL > /etc/network/interfaces
auto eth0
iface eth0 inet dhcp
EOL
rc-update add networking default
cat <<EOL > /etc/resolv.conf
nameserver 8.8.8.8
EOL
cat <<EOL > /etc/hostname
pppwn-luckfox
EOL
cat <<EOL > /etc/ssh/sshd_config
PermitRootLogin yes
HostKey /etc/ssh/ssh_host_rsa_key
ChallengeResponseAuthentication no
PasswordAuthentication yes
LoginGraceTime 8
X11Forwarding no
PrintMotd no
MaxStartups 2:30:10
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
EOL
cat <<EOL > /etc/passwd 
root:x:0:0:root:/root:/bin/ash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/mail:/sbin/nologin
news:x:9:13:news:/usr/lib/news:/sbin/nologin
uucp:x:10:14:uucp:/var/spool/uucppublic:/sbin/nologin
cron:x:16:16:cron:/var/spool/cron:/sbin/nologin
ftp:x:21:21::/var/lib/ftp:/sbin/nologin
sshd:x:22:22:sshd:/dev/null:/sbin/nologin
games:x:35:35:games:/usr/games:/sbin/nologin
ntp:x:123:123:NTP:/var/empty:/sbin/nologin
guest:x:405:100:guest:/dev/null:/sbin/nologin
nobody:x:65534:65534:nobody:/:/sbin/nologin
EOL
cp -r /pppwn/* /root
chmod +x /root/alpine_install_system.sh
chmod +x /root/alpine_pppwn_install.sh
chmod +x /root/alpine_package_system.sh
echo "root:pppwn" | chpasswd
exec /root/alpine_pppwn_install.sh

