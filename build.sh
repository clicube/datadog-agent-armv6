#! /bin/bash

cd ~
apt update

echo "Uninstall existing mercurial"
apt -y remove mercurial
apt -y --purge autoremove

echo "Install pip and invoke"
apt install -y python python-dev
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
pip install invoke

echo "Build datadog-agent"
export GOPATH=/go
export PATH=$GOPATH/bin:$PATH
git clone https://github.com/DataDog/datadog-agent.git $GOPATH/src/github.com/DataDog/datadog-agent
cd $GOPATH/src/github.com/DataDog/datadog-agent
pip install -r requirements.txt
invoke deps
GOOS=linux GOARCH=arm GOARM=6 invoke agent.build --puppy
cd ./bin
tar zcvf ~/datadog-agent.tar.gz ./agent
cd ~
