#!/bin/bash
wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -O jq
chmod +x jq
HOSTS=`cat attrs.json | ./jq -r '.hadoop.hadoop_hosts.datanodes' |sed  "/\[\|\]/d" | tr -d ',\n' |tr -d '"'`
DEPLOYMENT_DIR=`cat attrs.json | ./jq -r '.deploy.directory' |sed  "/\[\|\]/d" | tr -d ',\n' |tr -d '"'`
mkdir -p $DEPLOYMENT_DIR
cd $DEPLOYMENT_DIR
nohup python $HOST:$DEPLOYMENT_DIR/deploy/henchman.py &
wget http://www-eu.apache.org/dist/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz 
wget http://apache-mirror.rbc.ru/pub/apache/hbase/hbase-1.0.3/hbase-1.0.3-bin.tar.gz
for HOST in $HOSTS
do
        ssh $HOST 'mkdir -p $DEPLOYMENT_DIR'
	scp deploy.tar.gz $HOST:$DEPLOYMENT_DIR
	ssh $HOST 'tar -xzf $HOST:$DEPLOYMENT_DIR/deploy.tar.gz;\
        cd $DEPLOYMENT_DIR;\
	sudo yum install chef-12.12.15-1.el7.x86_64.rpm -y;\	
	sudo chef-solo -c $DEPLOYMENT_DIR/deploy/config.rb -j $DEPLOYMENT_DIR/deploy/attrs.json -o recipe[prepare_node];\
	sudo chef-solo -c $DEPLOYMENT_DIR/deploy/config.rb -j $DEPLOYMENT_DIR/deploy/attrs.json -o recipe[hadoop];\
	sudo chef-solo -c $DEPLOYMENT_DIR/deploy/config.rb -j $DEPLOYMENT_DIR/deploy/attrs.json -o recipe[hbase]\
	sudo nohup python $DEPLOYMENT_DIR/deploy/henchman.py &'
done