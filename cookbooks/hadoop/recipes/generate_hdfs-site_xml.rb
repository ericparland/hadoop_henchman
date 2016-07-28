#generate hdfs-site.xml
hadoop_user=node[:hadoop][:user]

template '/opt/hadoop/etc/hadoop/hdfs-site.xml' do
  source 'hdfs-site.xml.erb'
  mode '0775'
  owner #{hadoop_user}
  group #{hadoop_user}
  variables({
     :replication_factor => node[:hadoop][:replication_factor],
	 :hadoop_user => node[:hadoop][:user],
	 :data_folder => node[:hadoop][:data_folder],
     :master_host => node[:hadoop][:hadoop_hosts][:master],
     :namenode_port => node[:hadoop][:namenode_port]
  })  
end