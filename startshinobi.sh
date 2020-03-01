#!/bin/bash

# --- LINUX --- LINUX --- LINUX ---

# #########################################################
#
# oneMarcFifty
#
# #########################################################
# bash script to pull, create and start shinobi
# with persistent volumes on LINUX
# #########################################################

# #########################################################
# Adapt these parameters to your needs
# #########################################################

CONTAINERNAME=shinobi
IMAGENAME=shinobicctv/shinobi
LOCALPORT=8081
VIDEOSTORAGE=/home/marc/shinobi/videos
DBSTORAGE=/home/marc/shinobi/database
CONFIGSTORAGE=/home/marc/shinobi/config

# #########################################################
# create the storage locations if they don't exist already
# #########################################################

mkdir -p $VIDEOSTORAGE
mkdir -p $DBSTORAGE
mkdir -p $CONFIGSTORAGE


# #########################################################
# Build the container if it does not exist already
# #########################################################

echo I am trying to build the container $CONTAINERNAME from image $IMAGENAME

[ ! "$(docker container ls -a | grep $CONTAINERNAME)" ] && docker create\
  --name $CONTAINERNAME -t \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -v $CONFIGSTORAGE:/config \
  -v $VIDEOSTORAGE:/opt/shinobi/videos \
  -v $DBSTORAGE:/var/lib/mysql \
  -v /dev/shm/shinobiDockerTemp:/dev/shm/streams \
  -p $LOCALPORT:8080 \
  $IMAGENAME 
  
# #########################################################
# If the create was successful then let's start it
# #########################################################

echo I am trying to start the container $CONTAINERNAME

[ ! "$(docker ps | grep $CONTAINERNAME)" ] && docker start $CONTAINERNAME
