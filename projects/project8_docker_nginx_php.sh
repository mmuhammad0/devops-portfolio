#!/usr/bin/env bash

sudo apt update
sudo apt install apache2 -y
sudo apt-get install libxml2-dev
sudo a2enmod rewrite
sudo a2enmod proxy
sudo a2enmod proxy_balancer
sudo a2enmod proxy_http
sudo a2enmod headers
sudo a2enmod lbmethod_bytraffic
sudo systemctl restart apache2

# Images:
