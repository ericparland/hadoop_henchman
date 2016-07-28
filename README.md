# hadoop_henchman

This is a small project created by me in order to solve test task for DevOPS position. 
The goal was to create a simple, yet manageble way to deploy, configure and maintain a small, 3-node cluster with Hadoop and HBase running on it.

I have decided to use chef-solo as deployment/configuration change engine (this will allow us to get rid of any server nodes or management nodes) and a simple Flask-based script-server which provides REST API interface to update configuration, run chef and maintain services called "the Henchman".
Hadoop was set up on 3 nodes:
1st node: NameNode, Secondary NameNode, DataNode, ResourceManager, NodeManager
2nd node: DataNode, NodeManager
3rd node: DataNode, NodeManager

HBase was set up on 3 nodes:
1st node: Master, Zookeeper
2nd node: Backup Master, Zookeeper, RegionServer
3rd node: Zookeeper, RegionServer

using for reference:
http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/ClusterSetup.html
http://www.tutorialspoint.com/hadoop/hadoop_multi_node_cluster.htm
https://hbase.apache.org/book.html#quickstart


The Henchman is a small server-like script, which serves as a REST API interface for host management.
  Right now there are 4 types of calls:
  - http://{address}/file/{somefile} - GET - for getting files from Henchman working directory (for example, configuration or recipe file)
  - http://{address}/api/run_chef - POST - serves for 2 purposes: to update config file (attr.json) and to run Chef with chosen steps. Send a POST  request like this:
    {
    "some_configuration":{
       "some_key":"some_value",
	   "some_keys":{
	        "some_hosts":["host01","host02","host03"]
  		}
        },
    "run_list": [
        "recipe[some_cookbook::some_recipe]"
      ]
    }
  - http://{address}/api/get_config - GET - get the config file (attr.json)
  - http://{address}/api/{hadoop,hbase}/{stop_datanode,start_hbase,etc} - GET - trigger some action

  TODO:
  - Daemonize this!!
  - Build RPM package
  - Add authorization
  - Add healthcheck feature (process statuses monitoring, system metrics
  - Rework API commands to something more convenient and reliable, maybe wrap them with Chef
  - Add UI and DB for historical data 
  - Rework cookbooks, add better passwordless ssh management (https://supermarket.chef.io/cookbooks/ssh-keys)


Right now the project is in very crude and unfinished state, it was thrown together by me in a couple of nights, so there are lots of things to be improved.
