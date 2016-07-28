master_host=node[:hadoop][:hadoop_hosts][:master]
hbase_distro=node[:hbase][:version]

execute 'untar' do
  command 'tar zxf /tmp/hbase.tar.gz -C /opt/; mv /opt/'+hbase_distro+' /opt/hbase'
  action :run
end





