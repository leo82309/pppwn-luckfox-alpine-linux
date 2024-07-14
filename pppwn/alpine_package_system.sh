#!/bin/sh
echo "Made by Reo_Auin for Luckfox Pico Alpine Linux Docker"
for d in bin etc lib root sbin usr; do tar c "$d" | tar x -C /rootfs; done
for dir in dev proc run sys var; do mkdir /rootfs/${dir}; done
cd /rootfs/ && tar czf alpine.tar.gz *
