master_host = node['hadoop']['hadoop_hosts']['master']

#Install some packages, these are not required, but I may want to use them in future
yum_package ['net-tools', 'wget','rsync','git'] do
  action :install
end

#Disable firewalld
service 'firewalld' do
  action [ :disable, :stop ]
end

#Disable IPv6
execute 'create sysctl conf file' do
  command 'echo "net.ipv6.conf.all.disable_ipv6 = 1" >>  /etc/sysctl.d/disableipv6.conf;sysctl -p /etc/sysctl.d/disableipv6.conf'
  creates '/etc/sysctl.d/disableipv6.conf'
  action :run
end

#Download and Install Java
if node['hostname'] != master_host
  bash 'get_java' do
    cwd '/tmp'                      
    code <<-EOH
      wget #{master_host}:5000/files/jdk-7u79-linux-x64.rpm -O /tmp/jdk.rpm; yum localinstall -y  /tmp/jdk.rpm
    EOH
end
else
  execute 'download Java' do
    command 'cp '+node['deploy']['directory']+'/jdk-7u79-linux-x64.rpm /tmp/jdk.rpm'
    creates '/tmp/jdk.rpm'
    action :run
  end
end

execute 'installJava' do
  command 'yum localinstall -y /tmp/jdk.rpm'
  creates '/usr/java/latest/bin/java'
  action :run
end

#Download and Install pip
execute 'install pip' do
  command 'curl "https://bootstrap.pypa.io/get-pip.py" -o "/tmp/get-pip.py"; python /tmp/get-pip.py; pip install flask'
  action :run
end


