#!/bin/bash
#
# Script to install OpenCV in Debian-based systems (Debian, Ubuntu, Linux Mint, etc.)
# Just because I'm a little bit lazy.
#
#            July 2014
# Felip Martí Carrillo
#


# Check OS
if [ ! $(command -v apt-get) ]; then
  echo -e "\e[1;31mERROR: Not a Debian-based linux system. Impossible to install OpenCV with this script\e[0;39m"
  exit 0
fi


# Before installing
echo -e "\e[1;34mUpdating the system\e[0;39m"
sudo apt-get update
END_CMD1=$?
sudo apt-get upgrade -y
END_CMD2=$?
if [ $END_CMD1 -ne 0 -o $END_CMD2 -ne 0 ]
then
	echo -e "\e[1;31mERROR: \e[39mWhen Updating the system\e[0m"
	exit 0
fi


# Install Compiler 
echo -e "\e[1;34mInstalling Compiler\e[0;39m"
sudo apt-get install build-essential -y
if [ $? -ne 0 ] 
then
    echo -e "\e[1;31mERROR: \e[39mWhen Installing Compiler\e[0m"
    exit 0
fi


# Install Required Requisites
echo -e "\e[1;34mInstalling Required Requisites\e[0;39m"
sudo apt-get install cmake git libgtk2.0-dev pkg-config python-dev python-numpy libavcodec-dev libavformat-dev libswscale-dev -y
if [ $? -ne 0 ] 
then
    echo -e "\e[1;31mERROR: \e[39mWhen Installing Required Requisites\e[0m"
    exit 0
fi


# Installing Optional Requisites
echo -e "\e[1;34mInstalling Optional Requisites\e[0;39m"
sudo apt-get install libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev -y
if [ $? -ne 0 ] 
then
    echo -e "\e[1;33mWARNING: \e[39mError when Installing Optional Requisites\e[0m"
fi


# Downloading the Cutting-edge OpenCV from the Git Repository
echo -e "\e[1;34mDownloading Cutting-edge OpenCV\e[0;39m"
opencv_DIR=`ls ~/source | grep opencv`
if [ "$opencv_DIR" != "opencv" ]
then
	cd
    mkdir source
    cd ~/source
	git clone https://github.com/Itseez/opencv.git
	if [ $? -ne 0 ] 
	then
	    echo -e "\e[1;31mERROR: \e[39mWhen Downloading the cutting-edge OpenCV" 
	    echo -e "       Check your internet connection" 
	    echo -e "       Check this url: https://github.com/Itseez/opencv.git" 
	    echo -e "       Check your git program\e[0m" 
	    exit 0
	fi
else
	cd ~/source/opencv
	sudo git pull
	if [ $? -ne 0 ] 
	then
	    echo -e "\e[1;31mERROR: \e[39mWhen Updating the cutting-edge OpenCV" 
	    echo -e "       Check if this folder /opt/opencv is generating conflicts" 
	    echo -e "       If you don't know please change the name of the folder /opt/opencv" 
	    echo -e "       Check your internet connection" 
	    echo -e "       Check this url: https://github.com/Itseez/opencv.git" 
	    echo -e "       Check your git program\e[0m" 
	    exit 0
	fi
fi


# Preparing Installation
echo -e "\e[1;34mPreparing Installation\e[0;39m"
cd ~/source/opencv
mkdir release
cd release

cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local ..
if [ $? -ne 0 ] 
then
    echo -e "\e[1;31mERROR: \e[39mWhen generating Makefile for the installation\e[0m" 
    exit 0
fi


# Building
echo -e "\e[1;34mCompiling\e[0;39m"
make
if [ $? -ne 0 ]
then
    echo -e "\e[1;31mERROR: \e[39mWhen Compiling\e[0m" 
    exit 0
fi


# Installing
echo -e "\e[1;34mInstalling\e[0;39m"
sudo make install
if [ $? -ne 0 ]
then
    echo -e "\e[1;31mERROR: \e[39mWhen Installing\e[0m" 
    exit 0
else
    echo -e "\e[1;32mInstallation has SUCCEED! :-) \e[0;39m" 

	echo -e "\e[1;34mDo you want to remove Instalation files? 
    If you want to be on the cutting edge of OpenCV don't remove, and execute regularly this script\e[0m"
	select yn in "Yes" "No"; do
	    case $yn in
	        Yes ) echo "   Removing..."; sudo rm -rf ~/source/opencv; break;;
	        No ) echo "   Not removing"; break;;
	    esac
	done	
    echo -e "\e[1;32m   DONE! \e[0;39m" 

fi

exit 1
