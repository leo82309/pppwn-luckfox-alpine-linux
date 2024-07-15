# pppwn-luckfox-alpine-linux
Build scripts for making a pppwn alpine linux install using luckfox's sdk

This repo is based off of [0x1iii1ii's](https://github.com/0x1iii1ii/PPPwn-Luckfox) early luckfox work and [walker2048's](https://bbs.eeworld.com.cn/thread-1259828-1-1.html) alpine linux guide for the luckfox pico line of computers. Also thanks to [thefl0w's](https://github.com/TheOfficialFloW/PPPwn) work on the pppwn exploit and lastly [xfangfang](https://github.com/xfangfang/PPPwn_cpp) for their c++ port of pppwn.

### Install Dependencies
Required:
* [Luckfox-Pico SDK](https://github.com/LuckfoxTECH/luckfox-pico)
* [Docker](https://www.docker.com/)

### Building an Alpine-Linux custom-rootfs

clone this repo to your home folder
```shell
git clone https://github.com/leo82309/pppwn-luckfox-alpine-linux.git
```

Using docker, allow qemu to emulate arm7.
```shell
docker run --rm --privileged multiarch/qemu-user-static --reset --persistent yes
```
Create a new rootfs folder in the pppwn-luckfox-alpine-linux folder.
```shell
mkdir ~/pppwn-luckfox-alpine-linux/rootfs
```

Setup an alpine linux arm7 docker using the following command.
```shell
docker run -it --name armv7alpine --platform linux/arm/v7 --net=host -v ~/pppwn-luckfox-alpine-linux/rootfs:/rootfs -v ~/pppwn-luckfox-alpine-linux/pppwn:/pppwn arm32v7/alpine
```

Using the docker shell input.
```shell
chmod +x /pppwn/alpine_install_system.sh
./pppwn/alpine_install_system.sh
```
Type in the desired ps4 firmware and confirm then run
```shell
./pppwn/alpine_package_system.sh
exit
```
Copy the alpine linux custom rootfs to the luckfox-pico sdk
```shell
mkdir ~/luckfox-pico/sysdrv/custom_rootfs
cp ~/pppwn-luckfox-alpine-linux/rootfs/alpine.tar.gz ~/luckfox-pico/sysdrv/custom_rootfs
```
Copy over my modified files for the sdk
```shell
cp -r ~/pppwn-luckfox-alpine-linux/luckfox-pico/* ~/luckfox-pico
```
Build the image for your luckfox pico device (Only setup for device `[3]RV1103_Luckfox_Pico_Plus` & `[4]RV1106_Luckfox_Pro_Max`).
```shell
cd ~/luckfox-pico/
./build.sh all
```
Your compiled firmware will be in ~/luckfox-pico/output/image


