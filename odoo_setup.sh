#!/bin/bash
################################################################################
#Script for installing setup Odoo on Ubuntu 23.04 (could be used for other version too)
#HELP: Run script on home directory
#RUN:. odoo_setup.sh

PYTHON_INSTALL="True"
POSTGRESQL_INSTALL="True"
ANACONDA_INSTALL="True"
WORKSPACE_DIR="$HOME/workspace"


echo -e "\n----------Start----------"
read -p "Enter odoo versions number for setup(Add version number, for multiple use space Ex:15 16):" VNAMES

if ! [[ $VNAMES =~ (^|[^0-9.])(15|16|17)([^0-9.]|$) ]];then 
    echo "Wrong input for odoo versions !"
    return
fi

sudo apt-get update
sudo apt-get upgrade -y


if [ $PYTHON_INSTALL = "True" ]; then
    echo -e "\n--- Installing Python 3 + pip3 --"
    sudo apt-get install git python3 python3-pip build-essential wget python3-dev python3-venv python3-wheel libxslt-dev libzip-dev libldap2-dev libsasl2-dev python3-setuptools node-less libpng12-0 libjpeg-dev gdebi -y
else
    echo -e "\n----------skipped installing python3----------"
fi


if [ $POSTGRESQL_INSTALL = "True" ]; then
    echo -e "\n---- Install PostgreSQL Server ----"
    sudo apt-get install postgresql postgresql-server-dev-all -y
else
    echo -e "\n----------skipped installing postgresql----------"
fi


if [ $ANACONDA_INSTALL = "True" ]; then
    echo -e "\n---- Install PostgreSQL Anaconda ----"
    sudo apt install curl bzip2 -y
    curl --output anaconda.sh https://repo.anaconda.com/archive/Anaconda3-5.3.1-Linux-x86_64.sh
    sha256sum anaconda.sh
    bash anaconda.sh
    source ~/.bashrc
    conda --version
else
    echo -e "\n----------skipped installing anaconda----------"
fi



mkdir $WORKSPACE_DIR
echo -e "\n====workspace created at $WORKSPACE_DIR"
cd $WORKSPACE_DIR

for ODOOV in $VNAMES
do
    echo -e "\n====create==dir for odoo$ODOOV"
    mkdir odoo$ODOOV
    cd $WORKSPACE_DIR/odoo$ODOOV
    mkdir -p enterprise odoo projects
    cd $WORKSPACE_DIR/odoo$ODOOV/odoo
    conda create -n env_odoo$ODOOV python=3.10
    conda activate env_odoo$ODOOV
    git clone https://www.github.com/odoo/odoo --depth 1 --branch $ODOOV.0 --single-branch .
    pip3 install -r requirements.txt
    pip3 install libsass==0.22.0
    conda deactivate
    conda deactivate
    cd $WORKSPACE_DIR
done
