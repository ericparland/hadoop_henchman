#Establish passwordless ssh
#TODO: rework this to something smarter of a solution

hbase_user=node[:hbase][:user]

cookbook_file '/home/'+hbase_user+'/.ssh/id_rsa' do
  source 'id_rsa'
  owner  hbase_user
  group  hbase_user
  mode '0700'
  action :create  
end

cookbook_file '/home/'+hbase_user+'/.ssh/id_rsa.pub' do
  source 'id_rsa.pub'
  owner  hbase_user
  group  hbase_user
  mode '0700'
  action :create
end

cookbook_file '/home/'+hbase_user+'/.ssh/authorized_keys' do
  source 'authorized_keys'
  owner  hbase_user
  group  hbase_user
  mode '0700'
  action :create
end

cookbook_file '/home/'+hbase_user+'/.ssh/known_hosts' do
  source 'known_hosts'
  owner  hbase_user
  group  hbase_user
  mode '0700'
  action :create
end

