#generate .bashrc
hadoop_user=node[:hadoop][:user]

template '/home/'+hadoop_user+'/.bashrc' do
  source 'bashrc.erb'
  mode '0770'
  owner hadoop_user
  group hadoop_user
  notifies :run, 'template[/opt/hadoop/etc/hadoop/hadoop-env.sh]'
end

template '/opt/hadoop/etc/hadoop/hadoop-env.sh' do
  source 'hadoop-env.sh.erb'
  mode '0775'
  owner hadoop_user
  group hadoop_user
end