#generate backup-masters
hbase_user=node[:hbase][:user]

template '/opt/hbase/conf/backup-masters' do
  source 'backup-masters.erb'
  mode '0775'
  owner #{hbase_user}
  group #{hbase_user}
  variables({
	 :backup_master_nodes => node[:hbase][:hbase_hosts][:backup_master_nodes]
  })  
end