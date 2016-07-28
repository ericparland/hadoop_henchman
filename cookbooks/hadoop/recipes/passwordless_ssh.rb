#Establish passwordless ssh
#TODO: rework this to something smarter of a solution

hadoop_user=node[:hadoop][:user]

cookbook_file '/home/'+hadoop_user+'/.ssh/id_rsa' do
  source 'id_rsa'
  owner  hadoop_user
  group  hadoop_user
  mode '0700'
  action :create  
end

cookbook_file '/home/'+hadoop_user+'/.ssh/id_rsa.pub' do
  source 'id_rsa.pub'
  owner  hadoop_user
  group  hadoop_user
  mode '0700'
  action :create
end

cookbook_file '/home/'+hadoop_user+'/.ssh/authorized_keys' do
  source 'authorized_keys'
  owner  hadoop_user
  group  hadoop_user
  mode '0700'
  action :create
end

cookbook_file '/home/'+hadoop_user+'/.ssh/known_hosts' do
  source 'known_hosts'
  owner  hadoop_user
  group  hadoop_user
  mode '0700'
  action :create
end
