#!/bin/bash
# Author: Thirumalai Aiyalu
# E-mail: taiyalu@amazon.com or thiru85@gmail.com
# This installation script is part of the Mosquitto component for installation on a Greengrass v2 Core Device and accompanies a JSON Recipe for said component
# Installation steps are in README.MD

# This should deploy well on a Raspberry Pi
. /etc/os-release

# Make the directories to download the manifests/lists for Mosquitto

if [[ ! -d $1/manifest ]]; then
      mkdir -p $1/manifest
fi

if [[ ! -d $1/lists ]]; then
      mkdir -p $1/lists
fi

# Check Raspbian version number and set variable accordingly

if [[ $VERSION_ID = "9" ]]; then
      VER="stretch"
elif [[ $VERSION_ID = "10" ]]; then
      VER="buster"
fi

# Kinda self-explanatory, the next few lines

curl http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key -o $1/manifest/mosquitto-repo.gpg.key

apt-key add $1/manifest/mosquitto-repo.gpg.key

curl http://repo.mosquitto.org/debian/mosquitto-$VER.list -o $1/lists/mosquitto-$VER.list

cp $1/lists/mosquitto-stretch.list /etc/apt/sources.list.d/

apt-get update
apt-get install mosquitto mosquitto-clients --yes

# Stopping service and making changes to the config file so that the Broker listens on the correct interface and ports

systemctl stop mosquitto.service

MOSQUITTO_PORT=1883
MQTT_BROKER_IP='0.0.0.0'

touch /etc/mosquitto/conf.d/local.conf

cat /dev/null > /etc/mosquitto/conf.d/local.conf

echo -e "\nlistener $MOSQUITTO_PORT $MQTT_BROKER_IP\nallow_anonymous true\n" >> /etc/mosquitto/conf.d/local.conf

# Starting service with the correct configurations.

systemctl start mosquitto.service