#!/bin/bash

#Application Install
sudo apt update
sudo apt install -y default-jre
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa 
sudo apt install -y python3.7 
sudo apt install -y python3.7-venv