#!/usr/bin/env bash

sudo apt update
sudo apt install nginx
sudo systemctl restart nginx
sudo systemctl status nginx
sudo certbot --nginx -d biuldwithme.link -d www.buildwithme.link

# Images:
