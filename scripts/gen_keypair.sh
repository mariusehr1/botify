#!/bin/bash
if [ "$#" -lt 2 ]; then
    echo "This scripts uses two mandatory parameters : username and server ip"
    echo "Usage: ./$0 [USERNAME] [SERVERNAME] OPTIONAL[PORT]"
    exit 1
fi
if [ ! -d $HOME/.ssh ] 
then
	mkdir -p $HOME/.ssh
fi
chmod 0700 $HOME/.ssh
ssh-keygen -t rsa -f $HOME/.ssh/id_rsa -q -N ""
if [ "$#" == 3 ]; then
	ssh-copy-id -i $HOME/.ssh/id_rsa.pub $1@$2 -p $3
else
	ssh-copy-id -i $HOME/.ssh/id_rsa.pub $1@$2
fi
