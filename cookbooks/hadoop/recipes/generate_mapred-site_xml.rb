#generate mapred-site.xml
hadoop_user=node[:hadoop][:user]

template '/opt/hadoop/etc/hadoop/mapred-site.xml' do
  source 'mapred-site.xml.erb'
  mode '0775'
  owner #{hadoop_user}
  group #{hadoop_user}
  variables({
	 :mapreduce_job_tracker_port => node[:hadoop][:yarn][:resource_manager][:mapreduce_job_tracker_port],
     :resource_manager_host => node[:hadoop][:yarn][:resource_manager][:host]
  })  
end