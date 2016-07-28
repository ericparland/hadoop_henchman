hadoop_user=node[:hadoop][:user]
hbase_user=node[:hbase][:user]

#Create user for hbase and give him permissions

user hbase_user do
  comment 'User to launch HBase distribution'
  shell '/bin/bash'
end

group hbase_user do
  action :create
  members hbase_user
  append true
end

group hadoop_user do
  action :modify
  members hbase_user
  append true
end

directory '/opt/hbase' do
  owner hbase_user
  group hbase_user
  mode '0775'
  recursive true
end

directory "/home/"+hbase_user+"/.ssh" do
  owner hbase_user
  group hbase_user
  mode '0700'
  action :create
end

