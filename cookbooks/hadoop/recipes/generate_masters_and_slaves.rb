#generate masters and slaves file
hadoop_user=node[:hadoop][:user]

template '/opt/hadoop/etc/hadoop/masters' do
  source 'masters.erb'
  mode '0775'
  owner #{hadoop_user}
  group #{hadoop_user}
  variables({
     :master_host => node[:hadoop][:hadoop_hosts][:master]
  })  
end

template '/opt/hadoop/etc/hadoop/slaves' do
  source 'slaves.erb'
  mode '0775'
  owner #{hadoop_user}
  group #{hadoop_user}
  variables({
     :slaves => node[:hadoop][:hadoop_hosts][:datanodes],
  })  
end