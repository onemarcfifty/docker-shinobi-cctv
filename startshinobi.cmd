@ECHO OFF

REM --- WINDOWS --- WINDOWS --- WINDOWS ---

REM #########################################################
REM
REM oneMarcFifty
REM
REM #########################################################
REM CMD script to pull, create and start shinobi
REM with persistent volumes
REM #########################################################

REM #########################################################
REM Adapt these parameters to your needs
REM #########################################################

SET CONTAINERNAME=shinobi
SET IMAGENAME=shinobicctv/shinobi
SET LOCALPORT=8081

REM you need to have full control rights on these 

SET VIDEOSTORAGE=C:/users/marc/shinobi/videos
REM SET DBSTORAGE=C:/users/marc/shinobi/database
SET CONFIGSTORAGE=C:/users/marc/shinobi/config

REM #########################################################
REM create the storage locations if they don't exist already
REM be careful with the path names - Windows does not
REM support forward slashes in the beginning of a path name
REM /home => unsupported
REM C:/home or ./home => supported
REM #########################################################

mkdir "%VIDEOSTORAGE%"
REM mkdir "%DBSTORAGE%"
mkdir "%CONFIGSTORAGE%"

REM MariaDB Bug on Windows Docker Desktop

docker volume create database

REM #########################################################
REM Build the container if it does not exist already
REM #########################################################

echo I am trying to build the container %CONTAINERNAME% from image %IMAGENAME%

docker create^
  --name %CONTAINERNAME% -t ^
  --mount source=database,target=/var/lib/mysql ^
  -v "%CONFIGSTORAGE%":/config:rw ^
  -v "%VIDEOSTORAGE%":/opt/shinobi/videos:rw ^
  -v /dev/shm/shinobiDockerTemp:/dev/shm/streams:rw ^
  -p %LOCALPORT%:8080 ^
  %IMAGENAME% 


REM   -v "%DBSTORAGE%":/var/lib/mysql:rw 

REM #########################################################
REM If the create was successful then let's start it
REM #########################################################

echo I am trying to start the container %CONTAINERNAME%

docker start %CONTAINERNAME%
