data_folder=node[:hadoop][:data_folder]
hadoop_user=node[:hadoop][:user]

#Create user for hadoop and give him permissions

user hadoop_user do
  comment 'User to launch Hadoop distribution'
  shell '/bin/bash'
end

group hadoop_user do
  action :create
  members hadoop_user
  append true
end

directory '/opt/hadoop' do
  owner hadoop_user
  group hadoop_user
  mode '0775'
  recursive true
end

directory data_folder do
  owner hadoop_user
  group hadoop_user
  mode '0775'
  recursive true
end

directory "/home/"+hadoop_user+"/.ssh" do
  owner hadoop_user
  group hadoop_user
  mode '0700'
  action :create
end

