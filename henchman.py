#!/bin/python
import flask
import json
import time
import logging
import os

#---------------------- Created by EP, 2016 ----------------------
#  This is the Henchman - the small server-like script, which serves as a REST API interface for host management.
#  Right now there are 4 types of calls:
#  - http://{address}/file/{somefile} - GET - for getting files from Henchman working directory (for example, configuration or recipe file)
#  - http://{address}/api/run_chef - POST - serves for 2 purposes: to update config file (attr.json) and to run Chef with chosen steps. Send a POST  request like this:
#    {
#    "some_configuration":{
#       "some_key":"some_value",
#	   "some_keys":{
#	        "some_hosts":["host01","host02","host03"]
#  		}
#        },
#    "run_list": [
#        "recipe[some_cookbook::some_recipe]"
#      ]
#    }
#  - http://{address}/api/get_config - GET - get the config file (attr.json)
#  - http://{address}/api/{hadoop,hbase}/{stop_datanode,start_hbase,etc} - GET - trigger some action
#
#  TODO:
#  - Add authorization
#  - Add healthcheck feature (process statuses monitoring, system metrics
#  - Rework API commands to something more convenient and reliable, maybe wrap them with Chef
#  - Add UI and DB for historical data 
#
app = flask.Flask(__name__)

logpath = os.path.dirname(os.path.realpath(__file__))

FORMAT = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'

logging.basicConfig(format=FORMAT)

logger = logging.getLogger('agent.py')

logger.setLevel(logging.DEBUG)

def loadConfig():
    try:
        with open('attrs.json') as config_file:
            config = json.load(config_file)
    except Exception:
        logger.exception("Could not get attrs.json")
    return config

def regenerateJson(file,data):
    try:
            with open(file, 'w') as outfile:
                json.dump(data, outfile)
    except Exception:
            logger.exception("Could not dump data to "+str(file))
            logger.exception(data)

config=loadConfig()
@app.route("/files/<file_name>")
def getFile(file_name):
    return flask.send_file(file_name, as_attachment=True)

@app.route('/api/run_chef', methods=['POST'])
def run_chef():
    if not flask.request.json:
        flask.abort(400)
    regenerateJson('attrs.json',flask.request.json)
    config=loadConfig()
    try:
        logger.info("Starting Chef-run with following parameters: \n "+str(config))
        os.system('chef-solo -c config.rb -j attrs.json')
    except Exception:
        logger.exception("Could not run Chef")
    return flask.jsonify(flask.request.json), 201


@app.route('/api/get_config', methods=['GET'])
def get_config():
    return flask.jsonify(config), 200

@app.route('/api/hadoop/format_namenode', methods=['GET'])
def format_namenode():
    command = 'su '+ config["hadoop"]["user"] +' -c "/opt/hadoop/bin/hdfs namenode -format"'
    logger.info("Executing following command: "+command)
    os.system(command)
    return flask.jsonify({'format_namenode': 'triggered'}), 200

@app.route('/api/hadoop/stop_datanode', methods=['GET'])
def stop_datanode():
    command = 'su '+ config["hadoop"]["user"] +'  -c "/opt/hadoop/sbin/hadoop-daemons.sh --config /opt/hadoop/etc/hadoop/ --script hdfs stop datanode"'
    logger.info("Executing following command: "+command)
    os.system(command)
    return flask.jsonify({'stop_datanode': 'triggered'}), 200

@app.route('/api/hadoop/start_datanode', methods=['GET'])
def start_datanode():
    command = 'su '+ config["hadoop"]["user"] +' -c "/opt/hadoop/sbin/hadoop-daemons.sh --config /opt/hadoop/etc/hadoop/ --script hdfs start datanode"'
    logger.info("Executing following command: "+command)
    os.system(command)
    return flask.jsonify({'start_datanode': 'triggered'}), 200


@app.route('/api/hadoop/stop_namenode', methods=['GET'])
def stop_namenode():
    command = 'su '+ config["hadoop"]["user"] +' -c "/opt/hadoop/sbin/hadoop-daemons.sh --config /opt/hadoop/etc/hadoop/ --script hdfs stop namenode"'
    logger.info("Executing following command: "+command)
    os.system(command)
    return flask.jsonify({'stop_namenode': 'triggered'}), 200

@app.route('/api/hadoop/start_namenode', methods=['GET'])
def start_namenode():
    command = 'su '+ config["hadoop"]["user"] +'  -c "/opt/hadoop/sbin/hadoop-daemons.sh --config /opt/hadoop/etc/hadoop/ --script hdfs start namenode"'
    logger.info("Executing following command: "+command)
    os.system(command)
    return flask.jsonify({'start_namenode': 'triggered'}), 200

@app.route('/api/hadoop/start_dfs', methods=['GET'])
def start_dfs():
    command = 'su '+ config["hadoop"]["user"] +'  -c "/opt/hadoop/sbin/start-dfs.sh"'
    logger.info("Executing following command: "+command)
    os.system(command)
    return flask.jsonify({'start_dfs': 'triggered'}), 200

@app.route('/api/hadoop/stop_dfs', methods=['GET'])
def stop_dfs():
    command = 'su '+ config["hadoop"]["user"] +' -c "/opt/hadoop/sbin/stop-dfs.sh"'
    logger.info("Executing following command: "+command)
    os.system(command)
    return flask.jsonify({'stop_dfs': 'triggered'}), 200

@app.route('/api/hadoop/start_yarn', methods=['GET'])
def start_yarn():
    command = 'su '+ config["hadoop"]["user"] +' -c "/opt/hadoop/sbin/start-yarn.sh"'
    logger.info("Executing following command: "+command)
    os.system(command)
    return flask.jsonify({'stop_yarn': 'triggered'}), 200

@app.route('/api/hadoop/stop_yarn', methods=['GET'])
def stop_yarn():
    command = 'su '+ config["hadoop"]["user"] +' -c "/opt/hadoop/sbin/stop-yarn.sh"'
    logger.info("Executing following command: "+command)
    os.system(command)
    return flask.jsonify({'start_yarn': 'triggered'}), 200

@app.route('/api/hbase/start_hbase', methods=['GET'])
def start_hbase():
    command = 'su '+ config["hbase"]["user"] +'  -c "/opt/hbase/bin/start-hbase.sh"'
    logger.info("Executing following command: "+command)
    os.system(command)
    return flask.jsonify({'start_hbase': 'triggered'}), 200

@app.route('/api/hbase/stop_hbase', methods=['GET'])
def stop_hbase():
    command = 'su '+ config["hbase"]["user"] +' -c "/opt/hbase/bin/stop-hbase.sh"'
    logger.info("Executing following command: "+command)
    os.system(command)
    return flask.jsonify({'stop_yarn': 'triggered'}), 200




@app.errorhandler(404)
def not_found(error):
    return flask.make_response(flask.jsonify({'error': 'Not found'}), 404)

if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0')

