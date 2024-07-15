docker run --rm --privileged multiarch/qemu-user-static --reset --persistent yes
mkdir ~/pppwn-luckfox-alpine-linux/rootfs
docker run -it --name armv7alpine --platform linux/arm/v7 --net=host -v ~/pppwn-luckfox-alpine-linux/rootfs:/rootfs -v ~/pppwn-luckfox-alpine-linux/pppwn:/pppwn arm32v7/alpine

docker exec -it arm32v7/alpine /bin/bash chmod +x /pppwn/alpine_install_system.sh ./pppwn/alpine_install_system.sh
docker exec arm32v7/alpine ./pppwn/alpine_package_system.sh
exit

mkdir ~/luckfox-pico/sysdrv/custom_rootfs
cp ~/pppwn-luckfox-alpine-linux/rootfs/alpine.tar.gz ~/luckfox-pico/sysdrv/custom_rootfs

cp -r ~/pppwn-luckfox-alpine-linux/luckfox-pico/* ~/luckfox-pico

cd ~/luckfox-pico/
./build.sh all