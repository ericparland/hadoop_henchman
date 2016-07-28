master_host=node[:hadoop][:hadoop_hosts][:master]
hadoop_distro=node[:hadoop][:version]

execute 'untar' do
  command 'tar zxf /tmp/hadoop.tar.gz -C /opt/; mv /opt/'+hadoop_distro+' /opt/hadoop'
  action :run
end





