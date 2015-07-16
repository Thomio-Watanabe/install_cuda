#!/bin/bash

# Author: Thomio Watanabe
# License: GNU GPLv3 or later 

# Bash script to install CUDA
# Tested in:
#       - Ubuntu 14.04

# More information at:
# http://docs.nvidia.com/cuda/cuda-getting-started-guide-for-linux/index.html

red="$(tput setaf 1)"
green="$(tput setaf 2)"
standColor="$(tput sgr 0)"

# Verify if you have Cuda-Capable GPU:
if lspci | grep -i nvidia; then
    echo "${green}CUDA-Capable GPU found.${standColor}"
else
    echo "${red}CUDA-Capable GPU not found.${standColor}"
    echo "${red}Exit CUDA installtion process.${standColor}"
    exit
fi

# Verify You Have a Supported Version of Linux
# It must be x86_64
# cat /etc/*release
if uname -m | grep -i x86_64; then
    echo "${green}Linux x86_64 found.${standColor}"
else
    echo "${red}Linux x86_64 not found.${standColor}"
    echo "${red}Exit CUDA installtion process.${standColor}"
    exit
fi

# Verify the System Has gcc Installed
gcc --version
if [ ! $? -ne 0 ]
then
    echo "${green}Found gcc compiler.${standColor}"
else
    echo "${red}Gcc is not installed.${standColor}"
    echo "${red}Exit CUDA installtion process.${standColor}"
    exit
fi

## Remove old CUDA
echo "${green}Removing old CUDA instllations.${standColor}"
apt-get remove nvidia-cuda-*


# Check if CUDA deb installer exists in the current directory
file_name=cuda-repo-ubuntu1404-7-0-local_7.0-28_amd64.deb
current_path=`pwd`
#path_to_file="${current_path}/${file_name}"
path_to_file=./${file_name}
if [ -f "$path_to_file" ]; then
    echo "${green}File ${file_name} exists.${standColor}"
else
    # Download Ubuntu CUDA
    echo "${green}Downloading CUDA deb installer for Ubuntu 14.04.${standColor}"
    url=http://developer.download.nvidia.com/compute/cuda/7_0/Prod/local_installers/rpmdeb/cuda-repo-ubuntu1404-7-0-local_7.0-28_amd64.deb
    wget "${url}"
fi

## Install Ubuntu CUDA deb file
dpkg -i $file_name
apt-get update && apt-get install cuda


# Add CUDA resource paths to .bashrc and source it
bashrc_path=$HOME/".bashrc"
echo "# Export CUDA resource paths" >> $bashrc_path
echo "export PATH=/usr/local/cuda-7.0/bin:\$PATH" >> $bashrc_path
echo "export LD_LIBRARY_PATH=/usr/local/cuda-7.0/lib64:\$LD_LIBRARY_PATH" >> $bashrc_path
source $bashrc_path

