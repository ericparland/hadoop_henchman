#generate core-site.xml
hadoop_user=node[:hadoop][:user]
template '/opt/hadoop/etc/hadoop/core-site.xml' do
  source 'core-site.xml.erb'
  mode '0775'
  owner #{hadoop_user}
  group #{hadoop_user}
  variables({
     :master_host => node[:hadoop][:hadoop_hosts][:master],
     :namenode_port => node[:hadoop][:namenode_port]
  })  
end