#!/bin/bash

MosquittoRoot = $1

if [[ ! -d $MosquittoRoot/manifest ]]; then
      mkdir -p $MosquittoRoot/manifest
fi

if [[ ! -d $mlRootPath/lists ]]; then
      mkdir -p $MosquittoRoot/lists
fi

curl http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key -o $MosquittoRoot/manifest/mosquitto-repo.gpg.key

apt-key add $MosquittoRoot/manifest/mosquitto-repo.gpg.key

curl http://repo.mosquitto.org/debian/mosquitto-stretch.list -o /etc/apt/sources.list.d

apt-get update
apt-get install mosquitto mosquitto-clients --yes

systemctl stop mosquitto.service

MOSQUITTO_PORT=1883
MQTT_BROKER_IP='0.0.0.0'

touch /etc/mosquitto/conf.d/local.conf
echo -e "\nlistener $MOSQUITTO_PORT $MQTT_BROKER_IP\nallow_anonymous true\n" >> /etc/mosquitto/conf.d/local.conf

systemctl start mosquitto.service