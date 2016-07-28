#generate hdfs-site.xml
hbase_user=node[:hbase][:user]

execute 'add_java' do
  command 'echo "export JAVA_HOME=/usr/java/latest" >> /opt/hbase/conf/hbase-env.sh'
  action :run
end


template '/opt/hbase/conf/hbase-site.xml' do
  source 'hbase-site.xml.erb'
  mode '0775'
  owner #{hbase_user}
  group #{hbase_user}
  variables({
	 :data_folder => node[:hadoop][:data_folder],
     :master_host => node[:hadoop][:hadoop_hosts][:master],
     :namenode_port => node[:hadoop][:namenode_port],
	 :zk_nodes => node[:hbase][:hbase_hosts][:zk_nodes]
  })  
end