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
```json
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
```
  - http://{address}/api/get_config - GET - get the config file (attr.json)
  - http://{address}/api/{hadoop,hbase}/{stop_datanode,start_hbase,etc} - GET - trigger some action


Example:
Let's say, we want to change something in our configuration, for example, HDFS replication factor from 1 to 3.
With henchman it's easy. All we need to do is to:
1. Update variables configuration
2. Re-generate hdfs-site 
3. Re-start HDFS

Here is our configuration file:
```json
{
    "deploy":{
	    "directory":"/home/develop/deploy"
	},
    "hadoop":{
        "version":"hadoop-2.6.0",
        "user":"hadoop",
        "namenode_port":"9000",
        "hadoop_hosts":
        {
        "master":"test-01",
        "datanodes":["test-01","test-02","test-03"]	  
        },
        "replication_factor":"3",
        "data_folder":"/data",
	    "yarn":{
	        "resource_manager":
	        {
	        "host":"test-01",
	        "resource_manager_port":"8050",
	        "scheduler_port":"8035",
	        "resource-tracker_port":"8025",
	    	"mapreduce_job_tracker_port":"5431"
	        }
	}
  },
  "hbase":{
       "user":"hbase",
	   "version":"hbase-1.0.3",
	   "hbase_hosts":{
	        "zk_nodes":["test-01","test-02","test-03"],
 			"regionserver_nodes":["test-02","test-03"],
			"backup_master_nodes":["test-02"]
		}
  },
    "run_list": [
        "recipe[hadoop::generate_hdfs-site_xml]"
    ]
}
```
We have changed replication factor and we can save it as attrs.json. After that we perform curl for all our nodes:
``` bash
HOSTS=`cat attrs.json | ./jq -r '.hadoop.hadoop_hosts.datanodes' |sed  "/\[\|\]/d" | tr -d ',\n' |tr -d '"'`
for HOST in $HOSTS
do
   curl -vX POST http://$HOST:5000/api/run_chef -d @attrs.json --header "Content-Type: application/json"
done
``` 
Then, we restart HDFS:
``` bash
curl -i test-01:5000/api/hadoop/stop_dfs; curl -i test-01:5000/api/hadoop/start_dfs
``` 
And it's done.

  TODO:
  - Daemonize this!!
  - Build RPM package
  - Add authorization
  - Add healthcheck feature (process statuses monitoring, system metrics
  - Rework API commands to something more convenient and reliable, maybe wrap them with Chef
  - Add UI and DB for historical data 
  - Rework cookbooks, add better passwordless ssh management (https://supermarket.chef.io/cookbooks/ssh-keys)


Right now the project is in very crude and unfinished state, it was thrown together by me in a couple of nights, so there are lots of things to be improved.
