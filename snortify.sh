#! /bin/bash

projectDir="/Snortify"

if [ ! -d "$projectDir" ]
then
    echo "no dir"
    mkdir /Snortify
    cd /Snortify
else
    echo "dir"
    cd /Snortify
fi

echo "Shell Script to install latest Snort"
echo -e "-------------------------------------\n"

echo "Updating packages"
sudo apt update && apt upgrade -y


echo "Installing dependencies"
echo -e "-------------------------------\n"
sudo apt-get install openssh-server ethtool build-essential libpcap-dev libpcre3-dev libdumbnet-dev bison flex zlib1g-dev liblzma-dev openssl libssl-dev libluajit-5.1-dev pkg-config -y

echo "Fetching and Installing DAQ 2.0.6"
echo -e "---------------------------------\n"
wget https://www.snort.org/downloads/snort/daq-2.0.6.tar.gz
tar -zxvf daq-2.0.6.tar.gz

cd daq-2.0.6
./configure && make && make install

cd /Snortify
echo "Installing Snort 2.9.15 with OpenAppID and Debug mode enabled"
echo -e "-------------------------------------------------------------\n"
wget https://www.snort.org/downloads/snort/snort-2.9.15.tar.gz
tar -xvzf snort-2.9.15.tar.gz
cd snort-2.9.15

./configure
 --enable-debug-msgs
 --enable-debug
 --enable-gdb
 --enable-profile
 --enable-sourcefire
 --enable-buffer-dump
 --enable-non-ether-decoders

sudo make && make install

cd /Snortify

sudo ldconfig

ln -s /usr/local/bin/snort /usr/sbin/snort


echo "Configuring Snort"
echo -e "---------------------------\n"

mkdir /etc/snort
mkdir /etc/snort/preproc_rules
mkdir /etc/snort/rules
mkdir /var/log/snort
mkdir /usr/local/lib/snort_dynamicrules
touch /etc/snort/rules/white_list.rules
touch /etc/snort/rules/black_list.rules
touch /etc/snort/rules/local.rules

chmod -R 5775 /etc/snort/
chmod -R 5775 /var/log/snort/
chmod -R 5775 /usr/local/lib/snort

chmod -R 5775 /usr/local/lib/snort_dynamicrules/

cd snort-2.9.15/etc/

sudo cp -avr *.conf *.map *.dtd /etc/snort/

sudo cp -avr src/dynamic-preprocessors/build/usr/local/lib/snort_dynamicpreprocessor/* /usr/local/lib/snort_dynamicpreprocessor/

sudo sed -i "s/include \$RULE\_PATH/#include \$RULE\_PATH/" /etc/snort/snort.conf

echo "=============================================================="
echo "Enjoy Snort!"
echo "Just Configure /etc/snort/snort.conf according to your network"
echo "=============================================================="



