#!/usr/bin/env bash

sudo apt update
sudo apt install default-jdk-headless
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
sudo apt update
sudo apt-get install jenkins
sudo chown -R nobody:nobody /mnt
sudo chmod -R 777 /mnt

# Images:
