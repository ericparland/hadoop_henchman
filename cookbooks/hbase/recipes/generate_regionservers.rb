#generate regionservers
hbase_user=node[:hbase][:user]

template '/opt/hbase/conf/regionservers' do
  source 'regionservers.erb'
  mode '0775'
  owner #{hbase_user}
  group #{hbase_user}
  variables({
	 :regionserver_nodes => node[:hbase][:hbase_hosts][:regionserver_nodes]
  })  
end