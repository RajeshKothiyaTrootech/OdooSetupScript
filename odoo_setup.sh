#!/bin/bash
################################################################################
# Script for installing setup Odoo on Ubuntu 23.04 (could be used for other version too)
# Author: Trootech
# Execute the script to setup Odoo:
# . odoo_setup.sh
################################################################################

PYTHON_INSTALL="True"
POSTGRESQL_INSTALL="True"
ANACONDA_INSTALL="True"
WORKSPACE_DIR="$HOME/workspace"


echo -e "\n----------Start----------"
read -p "Enter odoo versions number for setup(Add version number, for multiple use space Ex:15 16 17):" VNAMES

if ! [[ $VNAMES =~ (^|[^0-9.])(15|16|17)([^0-9.]|$) ]];then 
    echo "Wrong input for odoo versions !"
    return
fi


sudo apt-get update
sudo apt-get upgrade -y


install_python(){
    echo -e "\n--- Installing Python 3 + pip3 --"
    sudo apt-get install git python3 python3-pip build-essential wget python3-dev python3-venv python3-wheel libxslt-dev libzip-dev libldap2-dev libsasl2-dev python3-setuptools node-less libpng12-0 libjpeg-dev gdebi -y
}

install_postgresql(){
    echo -e "\n---- Installing PostgreSQL Server ----"
    sudo apt-get install postgresql postgresql-server-dev-all -y
}

install_anaconda(){
    echo -e "\n---- Installing PostgreSQL Anaconda ----"
    sudo apt install curl bzip2 -y
    curl --output anaconda.sh https://repo.anaconda.com/archive/Anaconda3-5.3.1-Linux-x86_64.sh
    sha256sum anaconda.sh
    bash anaconda.sh
    source ~/.bashrc
    conda --version
}

setup_odoo(){
    echo -e "\n====create==dir for odoo$1"
    mkdir odoo$1
    cd $2/odoo$1
    mkdir -p enterprise odoo projects
    cd $2/odoo$1/odoo
    conda create -n env_odoo$1 python=3.10
    conda activate env_odoo$1
    git clone https://www.github.com/odoo/odoo --depth 1 --branch $1.0 --single-branch .
    pip3 install -r requirements.txt
    pip3 install libsass==0.22.0
    conda deactivate
    conda deactivate
    cd $2
}


if [ $PYTHON_INSTALL = "True" ]; then
    install_python
fi

if [ $POSTGRESQL_INSTALL = "True" ]; then
    install_postgresql
fi

if [ $ANACONDA_INSTALL = "True" ]; then
    install_anaconda
fi


mkdir $WORKSPACE_DIR
echo -e "\n====workspace created at $WORKSPACE_DIR"
cd $WORKSPACE_DIR

for ODOOV in $VNAMES
do
    setup_odoo $ODOOV $WORKSPACE_DIR
done
