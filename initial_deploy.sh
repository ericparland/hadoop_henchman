#!/bin/bash
sudo yum install wget -y
wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -O jq
chmod +x jq
HOSTS=`cat attrs.json | ./jq -r '.hadoop.hadoop_hosts.datanodes' |sed  "/\[\|\]/d" | tr -d ',\n' |tr -d '"'`
DEPLOYMENT_DIR=`cat attrs.json | ./jq -r '.deploy.directory' |sed  "/\[\|\]/d" | tr -d ',\n' |tr -d '"'`
mkdir -p $DEPLOYMENT_DIR
cd $DEPLOYMENT_DIR
cp ../jdk-7u79-linux-x64.rpm .
[  -f $DEPLOYMENT_DIR/hadoop-2.6.0.tar.gz ] || wget http://www-eu.apache.org/dist/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz 
[  -f $DEPLOYMENT_DIR/hbase-1.0.3-bin.tar.gz ] || wget http://apache-mirror.rbc.ru/pub/apache/hbase/hbase-1.0.3/hbase-1.0.3-bin.tar.gz
for HOST in $HOSTS
do
        ssh $HOST "[[ -d $DEPLOYMENT_DIR ]] || mkdir -p $DEPLOYMENT_DIR"
        scp ../deploy.tar.gz $HOST:$DEPLOYMENT_DIR
        ssh -tt $HOST -o IPQoS=throughput "stty raw -echo; cd $DEPLOYMENT_DIR; tar -xzvf $DEPLOYMENT_DIR/deploy.tar.gz; sudo yum install chef-12.12.15-1.el7.x86_64.rpm -y" < <(cat)
        ssh -tt $HOST -o IPQoS=throughput "stty raw -echo; sudo chef-solo -c $DEPLOYMENT_DIR/config.rb -j $DEPLOYMENT_DIR/attrs.json -o recipe[prepare_node]" < <(cat)
        if [[ $(ps -aufx | grep henchman | grep -v grep -c) > 0 ]]; then echo "Henchman is already running"; else sudo nohup python deploy/henchman.py &  fi;
        ssh -tt $HOST -o IPQoS=throughput "stty raw -echo; sudo nohup python $DEPLOYMENT_DIR/henchman.py &" < <(cat)
        #ssh -tt $HOST -o IPQoS=throughput "stty raw -echo; sudo chef-solo -c $DEPLOYMENT_DIR/config.rb -j $DEPLOYMENT_DIR/attrs.json -o recipe[hadoop]" < <(cat)
        #ssh -tt $HOST -o IPQoS=throughput "stty raw -echo; sudo chef-solo -c $DEPLOYMENT_DIR//config.rb -j $DEPLOYMENT_DIR/attrs.json -o recipe[hbase]" < <(cat)
done
