#generate yarn-site.xml
hadoop_user=node[:hadoop][:user]
template '/opt/hadoop/etc/hadoop/yarn-site.xml' do
  source 'yarn-site.xml.erb'
  mode '0775'
  owner #{hadoop_user}
  group #{hadoop_user}
  variables({
     :resource_tracker_port => node[:hadoop][:yarn][:resource_manager][:resource_tracker_port],
	 :scheduler_port => node[:hadoop][:yarn][:resource_manager][:scheduler_port],
	 :resource_manager_port => node[:hadoop][:yarn][:resource_manager][:resource_manager_port],
     :resource_manager_host => node[:hadoop][:yarn][:resource_manager][:host]
  })  
end